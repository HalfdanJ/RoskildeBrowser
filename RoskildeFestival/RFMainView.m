//
//  RFMainView.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFMainView.h"

@implementation RFMainView

-(void)awakeFromNib{
    bg = [NSColor colorWithPatternImage:[NSImage imageNamed:@"bg.png"]];

}
-(void)drawRect:(NSRect)rect
{
    [bg set];
    NSRectFill(rect);
}

@end
