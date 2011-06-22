//
//  RFXMLParser.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFXMLParser.h"
#import "SBJson.h"

@implementation RFXMLParser
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

-(void) startParsing{
   // NSLog(@"Start parsing");
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    
    //   NSString * jsonstring = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"file://localhost/Developer/Development/Code/Roskilde/roskildelinks.json"] encoding:NSUTF8StringEncoding error:nil];    
    
    NSMutableString* urlString = [NSMutableString stringWithCapacity:100];        
    [urlString setString:@"http://halfdanj.dk/roskilde/roskildelinks.json"];        
    [urlString appendString:@"?"];
    [urlString appendString:[[NSNumber numberWithLong:random()] stringValue]];
    
    
    NSString * jsonstring = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];    
    jsonFile = [parser objectWithString:jsonstring];
    NSLog(@"  %@",[jsonFile objectForKey:@"VETO"]);
    
    
    
    
    NSData * d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://roskilde-festival.dk/typo3conf/ext/tcpageheaderobjects/xml/bandobjects_251_uk.xml"]];
    NSAssert(d, @"XML calendar could not be downloaded!");
    
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
        //NSLog(@"Done with %@",tmpConcert);
    
        
        NSString * name = [NSString stringWithString:tmpConcert.name];

        if([jsonFile objectForKey:name]){
            
            if([[jsonFile objectForKey:name] objectForKey:@"itunes"] && ![[jsonFile objectForKey:name] objectForKey:@"link"]){
                NSString * link = [[jsonFile objectForKey:name] objectForKey:@"itunes"];
                NSMutableString* urlString = [NSMutableString stringWithCapacity:100];        
                [urlString setString:link];        
                [urlString appendString:@"?"];
                [urlString appendString:[[NSNumber numberWithLong:random()] stringValue]];
                
                
                                         

                
                NSString * itunesHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
                NSArray * previews = [itunesHtml componentsSeparatedByString:@"audio-preview-url=\""];
                
                if([previews count] < 2){
                    NSLog(@"Problem loading itunes html %@",link);
                } else {
                    NSString * preview = [previews objectAtIndex:1];
                    NSRange pos = [preview rangeOfString:@"\""];
                    preview = [preview substringToIndex:pos.location];
                    
                 //   NSLog(@"Preview : %@",preview);
                 //   url = [NSURL URLWithString:preview];
                    NSLog(@"\n%@ \n\"link\":\"%@\",",name, preview);
                }
            } 
        }else {
           // NSLog(@"No item in json file for |%@|",name);
        }

        
        
        
        [delegate addConcert:tmpConcert];
    }
    
    if ([elementName isEqual:keyInProgress]) {
        if([elementName isEqualToString:@"artistName"]){
            tmpConcert.name = [[textInProgress stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        else if([elementName isEqualToString:@"country"]){
            tmpConcert.country = [textInProgress stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];   
        }
        else if([elementName isEqualToString:@"scene"]){
            if([textInProgress isEqualToString:@""])
                [tmpConcert setSceneString:@"5"];
            else 
                [tmpConcert setSceneString:textInProgress];
        }
        else if([elementName isEqualToString:@"tidspunkt"]){
//            tmpConcert.date = [NSDate dateWithTimeIntervalSince1970:[textInProgress intValue]];
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
