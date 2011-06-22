//
//  RFWindow.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFWindow.h"

@implementation RFWindow
@synthesize controller;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(void)keyDown:(NSEvent *)theEvent{
    if([theEvent keyCode] == 49 || [theEvent keyCode] == 53){
        [controller stop];    
    }
    
}
@end
