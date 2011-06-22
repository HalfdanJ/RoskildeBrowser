//
//  RFController.h
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "RFConcertLayer.h"
#import "RFXMLParser.h"
#import "RFConcertObject.h"
#import "RFSoundCloud.h"

@class RFTopView;
@class RFAttachedView;

@interface RFController : NSObject{
    NSMutableArray * daysArray;
    NSMutableArray * concertArray;
    NSView *view;
    RFAttachedView *attachedView;
    RFXMLParser * rfParser;
    RFSoundCloud * soundcloud;
    

    
    NSView *topview;
}
@property (assign) IBOutlet NSView *topview;
@property (assign) IBOutlet NSView *view;
@property (assign) IBOutlet RFAttachedView *attachedView;
@property (readonly) NSMutableArray * concertArray;
@property (readonly) RFSoundCloud * soundcloud;

-(void) addConcert:(RFConcertObject*)concert;
-(void) finishedParsing;

@end
