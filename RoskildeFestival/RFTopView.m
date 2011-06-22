//
//  RFTopView.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFTopView.h"

@implementation RFTopView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)awakeFromNib{
    bg = [NSImage imageNamed:@"topbg.png"];
    
}
-(void)drawRect:(NSRect)rect
{
    [bg drawInRect:rect fromRect:rect operation:NSCompositeSourceOver fraction:1.0];

}


@end
