//
//  RFXMLParser.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFXMLParser.h"
#import "SBJson.h"

static NSDictionary * jsonFile;


@implementation RFXMLParser
@synthesize delegate;

+(NSDictionary*) jsonFile{
    return jsonFile;    
}

-(void) startParsing{
   // NSLog(@"Start parsing");
    SBJsonParser *jsonparser = [[SBJsonParser alloc] init];
    
    NSMutableString* urlString = [NSMutableString stringWithCapacity:100];        
    [urlString setString:@"http://halfdanj.dk/roskilde/roskildelinks.json"];        
    [urlString appendString:@"?"];
    [urlString appendString:[[NSNumber numberWithLong:random()] stringValue]];
    
    //Load josnfile from server
    NSString * jsonstring = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];    
    jsonFile = [jsonparser objectWithString:jsonstring];
    
    //Load concert data from roskilde server
    NSData * d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://roskilde-festival.dk/typo3conf/ext/tcpageheaderobjects/xml/bandobjects_251_uk.xml"]];
    NSAssert(d, @"XML calendar could not be downloaded!");
    
    //Parse concert info
    parser = [[NSXMLParser alloc] initWithData:d];
    [parser setDelegate:self];
    [parser parse];
}

#pragma mark Delegate calls

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"item"]) {
        tmpConcert = [[RFConcertObject alloc] init];
    } else if(tmpConcert != nil) {
        keyInProgress = [elementName copy];
        textInProgress = [[NSMutableString alloc] init];        
    }
}



- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"item"]) {
        BOOL doAdd = YES;
        NSString * name = [NSString stringWithString:tmpConcert.name];
        tmpConcert.relativeDuration = 1.0f;
        
        if([jsonFile objectForKey:name]){            
            if([[jsonFile objectForKey:name] objectForKey:@"short"]){
                tmpConcert.relativeDuration = 0.7f;
            } 
            if([[jsonFile objectForKey:name] objectForKey:@"relativeDuration"]){
                tmpConcert.relativeDuration = [[[jsonFile objectForKey:name] objectForKey:@"relativeDuration"] floatValue];
            }
            if([[jsonFile objectForKey:name] objectForKey:@"hidden"]){
                doAdd = NO;
            } 

        }else {
           // NSLog(@"No item in json file for |%@|",name);
        }
        
        if(doAdd){
            [delegate addConcert:tmpConcert];
        }
    }
    
    if ([elementName isEqual:keyInProgress]) {
        if([elementName isEqualToString:@"artistName"]){
            tmpConcert.name = [[textInProgress stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        else if([elementName isEqualToString:@"country"]){
            tmpConcert.country = [textInProgress stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];   
        }
        else if([elementName isEqualToString:@"scene"]){
            [tmpConcert setSceneString:textInProgress];
        }
        else if([elementName isEqualToString:@"tidspunkt"]){
            tmpConcert.date = [NSDate dateWithNaturalLanguageString:textInProgress ];
        }
        else if([elementName isEqualToString:@"text"]){
            tmpConcert.subtitle = textInProgress;   
        }
        else if([elementName isEqualToString:@"description"]){
            tmpConcert.longdescription = textInProgress;   
        }
        else if([elementName isEqualToString:@"prioritet"]){
            tmpConcert.priority = [textInProgress intValue];   
        }
        else if([elementName isEqualToString:@"imageUrl"]){
            tmpConcert.imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://roskilde-festival.dk/%@",textInProgress]];   
        }
        else if([elementName isEqualToString:@"mediumimageUrl"]){
            tmpConcert.smallImageUrl = [NSURL URLWithString:textInProgress];   
        }
        else if([elementName isEqualToString:@"link"]){
            tmpConcert.link = textInProgress;   
        }
    }
    
    if([elementName isEqualToString:@"bandPreview"]){
        [delegate finishedParsing];
    }
}
         
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
    [textInProgress appendString:string];
}

@end
