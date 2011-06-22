//
//  RFAttachedView.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFAttachedView.h"
#import "RFConcertObject.h"

@implementation RFAttachedView
@synthesize place;
@synthesize name;
@synthesize image;
@synthesize description, likeButton, dislikeButton, object;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

-(void)dislike:(id)sender{
    if([sender state]){
        object.rating = -1;
    } else {
        object.rating = 0;
    }
    [likeButton setState:0];
}

-(void)like:(id)sender{
    if([sender state]){
        object.rating = 1;
    } else {
        object.rating = 0;
    }
    [dislikeButton setState:0];
}

@end
