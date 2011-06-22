//
//  RFView.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFView.h"
#import "RFConcertLayer.h"

@implementation RFView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib{
    [self setNeedsDisplay:YES];
}

-(void)mouseDown:(NSEvent *)theEvent{
    [controller mouseDown:theEvent];
    CGPoint pointOfClick = NSPointToCGPoint([theEvent locationInWindow]);
    
    CALayer *hitLayer = [self.layer hitTest:pointOfClick];
    if ( (hitLayer != nil) && [hitLayer isKindOfClass:[RFConcertLayer class]])
    {
    //    [(RFConcertLayer *)hitLayer mouseDown:theEvent];
    }
    
    [super mouseDown:theEvent];
}



-(BOOL)isFlipped{
    return  YES;
}
@end
