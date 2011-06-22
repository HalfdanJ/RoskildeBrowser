//
//  RFXMLParser.h
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFConcertObject.h"

@interface RFXMLParser : NSObject<NSXMLParserDelegate>{
    id delegate;
    NSXMLParser * parser; 
    
    RFConcertObject * tmpConcert;
    NSMutableString * textInProgress;
    NSString * keyInProgress;
    
    NSDictionary * jsonFile;
}

@property (assign) id delegate;

-(void) startParsing;

@end
