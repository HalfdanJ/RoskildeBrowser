//
//  RFAttachedView.h
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RFAttachedView : NSView {
    NSImageView *image;
    NSTextView *description;
    NSTextField *name;
    NSTextField *place;
}
@property (assign) IBOutlet NSTextField *place;
@property (assign) IBOutlet NSTextField *name;

@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSTextView *description;

@end
