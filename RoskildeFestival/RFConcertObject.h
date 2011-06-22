//
//  RFConcertObject.h
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFConcertLayer.h"


@interface RFConcertObject : NSObject{
    NSString * name;
    NSString * country;
    int scene;
    NSDate * date;
    NSString * subtitle;
    NSString * longdescription;
    int priority;
    NSImage * image;
    NSImage * smallImage;
    NSURL * imageUrl;
    NSURL * smallImageUrl;
    NSString * link;
    int concertId;
    int day;
    
    float relativeDuration;
    
    RFConcertLayer * layer;
    
    int rating;
}

@property (retain) NSString * name;
@property (retain) NSString * country;
@property (retain) NSString * subtitle;
@property (retain) NSString * longdescription;
@property (retain) NSString * link;

@property (retain) NSURL * imageUrl;
@property (retain) NSURL * smallImageUrl;

@property (retain) NSDate * date;

@property (readwrite) int scene;
@property (readwrite) int priority;
@property (readwrite) int concertId;
@property (readwrite) int day;

@property (retain) NSImage * image;
@property (retain) NSImage * smallImage;

@property (retain) RFConcertLayer * layer;

@property (readwrite) float relativeDuration;
@property (readwrite) int rating;

-(void) setSceneString:(NSString*)string;

@end
