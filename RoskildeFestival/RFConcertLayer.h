//
//  ConcertLayer.h
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAAttachedWindow.h"
#import "RFSoundCloud.h"
#import <QuartzCore/QuartzCore.h>

@class RFController;
@class RFConcertObject;

@interface RFConcertLayer : CAGradientLayer{
    RFController * controller;
    RFConcertObject * concert;
    
    MAAttachedWindow *attachedWindow;
    
    RFSoundCloud * soundCloud;

}

@property (retain) RFConcertObject * concert;
@property (retain)  MAAttachedWindow *attachedWindow;

-(void) setController:(RFController*)controller;
-(void)mouseDown;

@end
