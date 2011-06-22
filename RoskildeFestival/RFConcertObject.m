//
//  RFConcertObject.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFConcertObject.h"

@implementation RFConcertObject
@synthesize date, link, name, scene, country, imageUrl, priority,subtitle,concertId,longdescription,smallImageUrl, day, smallImage, image, relativeDuration, rating;
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

-(void)setRating:(int)_rating{
    NSUserDefaults * shared = [NSUserDefaults standardUserDefaults];
    [shared setObject:[NSNumber numberWithInt:_rating] forKey:self.name];
    
    rating = _rating;
    if(rating == 1){
        layer.backgroundColor = CGColorCreateGenericRGB(0, 1, 0, 1);
    }
    if(rating == 0){
        layer.backgroundColor = CGColorCreateGenericRGB(0, 1, 0, 0);
    }
    if(rating == -1){
        layer.backgroundColor = CGColorCreateGenericRGB(1, 0, 0, 1);
    }

}

-(void)setLayer:(RFConcertLayer *)_layer{
    layer = _layer;
    [layer setConcert:self];
    
    if([self relativeDuration] != 1){
        [layer setBounds:CGRectMake(0, 0, layer.bounds.size.width, layer.bounds.size.height*self.relativeDuration)];
        [[[layer sublayers] objectAtIndex:0] setBounds:CGRectMake(0, 0, layer.bounds.size.width, layer.bounds.size.height*0.5)];
    }
   
    NSUserDefaults * shared = [NSUserDefaults standardUserDefaults];
    [self setRating:[[shared valueForKey:self.name] intValue]];

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
