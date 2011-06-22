//
//  RFWindow.h
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFController.h"

@interface RFWindow : NSWindow{
    
    RFController *controller;
}
@property (assign) IBOutlet RFController *controller;

@end
