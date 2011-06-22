//
//  RFSoundCloud.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "RFSoundCloud.h"

@implementation RFSoundCloud

-(id)init{
    self = [super init];
    if (self) {
        parser = [[SBJsonParser alloc] init];
        
        
    }
    
    return self;
}

-(void) stop{
    [streamer stop];
}

-(void) startSoundForArtist:(NSString*) artist{
    
    NSURL * url = nil;
    
    
    //Search in json file
    
//    NSString * jsonstring = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"file://localhost/Developer/Development/Code/Roskilde/roskildelinks.json"] encoding:NSUTF8StringEncoding error:nil];    
//    NSString * jsonstring = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://halfdanj.dk/roskilde/roskildelinks.json"] encoding:NSUTF8StringEncoding error:nil];    
    
    NSMutableString* urlString = [NSMutableString stringWithCapacity:100];        
    [urlString setString:@"http://halfdanj.dk/roskilde/roskildelinks.json"];        
    [urlString appendString:@"?"];
    [urlString appendString:[[NSNumber numberWithLong:random()] stringValue]];
    
    
    NSString * jsonstring = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];  
    
    NSDictionary * jsonFile = [parser objectWithString:jsonstring];
   //  NSLog(@"%@",jsonFile);
    if([jsonFile objectForKey:artist]){
        if([[jsonFile objectForKey:artist] objectForKey:@"link"]){
            url = [NSURL URLWithString:[[jsonFile objectForKey:artist] objectForKey:@"link"]];
            NSLog(@"Preview : %@",[[jsonFile objectForKey:artist] objectForKey:@"link"]);


        } else if([[jsonFile objectForKey:artist] objectForKey:@"itunes"]){
            NSString * link = [[jsonFile objectForKey:artist] objectForKey:@"itunes"];
            
            NSString * itunesHtml = [NSString stringWithContentsOfURL:[NSURL URLWithString:link] encoding:NSUTF8StringEncoding error:nil];
            NSArray * previews = [itunesHtml componentsSeparatedByString:@"audio-preview-url=\""];
            
            if([previews count] < 2){
                NSLog(@"Problem loading itunes html %@",link);
            } else {
                NSString * preview = [previews objectAtIndex:1];
                NSRange pos = [preview rangeOfString:@"\""];
                preview = [preview substringToIndex:pos.location];
                
                NSLog(@"Preview : %@",preview);
                url = [NSURL URLWithString:preview];
            }
        }
    }
    
    if(!url){
        //Else look in soundcloud 
        NSString * s = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks.json?client_id=a8c9fe82ea40224a63844b0a9c2c5d32&q=%@",[artist stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        NSURL * getUrl = [NSURL URLWithString:s];
        
        NSError * error;    
        NSString * data = [NSString stringWithContentsOfURL:getUrl encoding:NSUTF8StringEncoding error:&error];
        
        id object = [parser objectWithString:data];
        
        
        
        BOOL trackFound = NO;
        for(NSMutableDictionary * dict in object){
            NSLog(@"%@",[dict valueForKey:@"title"]);
            if([dict valueForKey:@"stream_url"] != nil){
                trackFound = YES;
                
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=a8c9fe82ea40224a63844b0a9c2c5d32", [dict valueForKey:@"stream_url"]]];
                
                NSURL *originalUrl=url;
                NSData *data=nil;  
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:originalUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:11];
                NSURLResponse *response;
                NSError *error;
                data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                NSURL *LastURL=[response URL];
                [request release];
                [error release];
                
                if(LastURL != nil)
                    url = LastURL;
                
                NSLog(@"Play %@  %@",[dict valueForKey:@"title"]);
                break;
                
            }
            
        }
    }
    
    if(url){
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
//        dispatch_async(queue, ^{
            streamer = [[AudioStreamer alloc] initWithURL:url];
  //          dispatch_async(dispatch_get_main_queue(), ^{
            [streamer start];
    //        });
      //  });

    }
}




@end
