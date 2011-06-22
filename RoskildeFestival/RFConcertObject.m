//
//  RFConcertObject.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFConcertObject.h"

@implementation RFConcertObject
@synthesize date, link, name, scene, country, imageUrl, priority,subtitle,concertId,longdescription,smallImageUrl, day, smallImage, image;
@synthesize layer;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)setDate:(NSDate *)_date{
    date = _date;
    NSInteger i = [date timeIntervalSinceDate:[NSDate dateWithString:@"2011-06-30 06:00:00 +0200"]];
    float d = i / (60.0*60.0*24);
    self.day = floor(d);

    //The date system is really stupid in the XML!
    if(i - floor(d)*(60.0*60.0*24.0) >= (60.0*60.0*18.0)){
        self.day = self.day+1;    
        date = [NSDate dateWithTimeInterval:(60.0*60.0*24.0) sinceDate:_date];
    }
    
}

-(void)setLayer:(RFConcertLayer *)_layer{
    layer = _layer;
    [layer setConcert:self];
}

-(void)setSceneString:(NSString *)string{
    if([string isEqualToString:@"Pavilion Junior"])
        self.scene = 0;
    if([string isEqualToString:@"Cosmopol"])
        self.scene = 1;
    if([string isEqualToString:@"Odeon"])
        self.scene = 2;
    if([string isEqualToString:@"Orange"]) 
        self.scene = 3;
    if([string isEqualToString:@"Gloria"])
        self.scene = 4;
    if([string isEqualToString:@"Arena"])
        self.scene = 5;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"Concert: %@ stage:%i day: %i date:%@", name, scene, day, date];
}

@end
