//
//  RFAttachedView.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFAttachedView.h"

@implementation RFAttachedView
@synthesize place;
@synthesize name;
@synthesize image;
@synthesize description;

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

-(void)keyDown:(NSEvent *)theEvent{
    NSLog(@"event %@",theEvent);
}

@end
