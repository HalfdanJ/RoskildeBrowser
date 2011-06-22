//
//  RFSoundCloud.h
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBJson.h"
#import "AudioStreamer.h"

@interface RFSoundCloud : NSObject{
    
    AudioStreamer *streamer;
    SBJsonParser *parser;
    BOOL stop;
}

-(void) startSoundForArtist:(NSString*) artist;
-(void) stop;
@end
