//
//  RFView.h
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RFController.h"
@interface RFView : NSView{
    IBOutlet RFController * controller;
}
@end
