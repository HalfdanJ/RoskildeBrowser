//
//  RFSoundCloud.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "RFSoundCloud.h"
#import "RFXMLParser.h"

@implementation RFSoundCloud

-(id)init{
    self = [super init];
    if (self) {
        parser = [[SBJsonParser alloc] init];
        stop = NO;
        
    }
    
    return self;
}

-(void) stop{
    [streamer stop];
    stop = YES;
}

-(void) startSoundForArtist:(NSString*) artist{
    NSURL * url = nil;    
    NSDictionary * jsonFile = [RFXMLParser jsonFile];
    //  NSLog(@"%@",jsonFile);
    if([jsonFile objectForKey:artist]){
        if([[jsonFile objectForKey:artist] objectForKey:@"link"]){
            url = [NSURL URLWithString:[[jsonFile objectForKey:artist] objectForKey:@"link"]];
            NSLog(@"Preview from itunes: %@",[[jsonFile objectForKey:artist] objectForKey:@"link"]);
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
                
                NSLog(@"Preview from itunes: %@",preview);
                url = [NSURL URLWithString:preview];
            }
        }
    }
    
    if(url){
        streamer = [[AudioStreamer alloc] initWithURL:url];
        [streamer start];
    }
    else {//Else look in soundcloud 
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        stop = NO;
        dispatch_async(queue, ^{
            NSString * s;
            if([jsonFile objectForKey:artist] && [[jsonFile objectForKey:artist] objectForKey:@"soundcloudq"]){
                
                s = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks.json?client_id=a8c9fe82ea40224a63844b0a9c2c5d32&q=%@",[[[jsonFile objectForKey:artist] objectForKey:@"soundcloudq"] stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
                
            } else {
                s = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks.json?client_id=a8c9fe82ea40224a63844b0a9c2c5d32&q=%@",[artist stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
            }
            
            NSURL * getUrl = [NSURL URLWithString:s];
            
            NSError * error;    
            NSString * data = [NSString stringWithContentsOfURL:getUrl encoding:NSUTF8StringEncoding error:&error];
            
            id object = [parser objectWithString:data];
            
            
            
            BOOL trackFound = NO;
            for(NSMutableDictionary * dict in object){
                if([dict valueForKey:@"stream_url"] != nil){
                    trackFound = YES;
                    
                    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=a8c9fe82ea40224a63844b0a9c2c5d32", [dict valueForKey:@"stream_url"]]];
                    
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
                    
                    NSLog(@"Play %@  on soundcloud",[dict valueForKey:@"title"]);
                    if(url){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(!stop){
                                streamer = [[AudioStreamer alloc] initWithURL:url];
                                [streamer start];
                            }
                        });
                        break;
                    }
                    
                }
                
            }
        });
    }
    
    
}




@end
