#import "RFConcertLayer.h"
#import "RFController.h"
#import "RFAttachedView.h"

@implementation RFConcertLayer
@synthesize concert, attachedWindow;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        attachedWindow = nil;
        soundCloud = [[RFSoundCloud alloc] init];
    }
    
    return self;
}

-(void) setController:(RFController*)_controller{
    controller = _controller;
}

-(void)mouseDown{
    //NSLog(@"mouse %@",self.concert);
    
    for(NSMutableArray * day in [controller concertArray]){
        for(NSMutableArray * stage in day){        
            for(RFConcertObject * _concert in stage){
                if(_concert.layer.attachedWindow && _concert != self.concert){
                    [_concert.layer mouseDown];
                }
            }
        }
    }
    
    if (!attachedWindow) {
        [soundCloud performSelector:@selector(startSoundForArtist:) withObject:concert.name afterDelay:0.0];
//        [soundCloud startSoundForArtist:concert.name];
        
        self.borderColor = CGColorCreateGenericRGB(0.0, 0.4, 0.4, 0.8);
        self.shadowColor = CGColorCreateGenericRGB(0, 0.4, 0.4, 1.0);
        self.shadowOffset = CGSizeMake(0, 0);
        self.shadowRadius = 2;
        self.shadowOpacity = 1.0;
        
        int side = 0;
        NSPoint buttonPoint = NSMakePoint(self.position.x, self.position.y);
        
        CALayer * superview = self.superlayer;
        while(superview != nil){
            if([superview superlayer]){
                buttonPoint = NSMakePoint(buttonPoint.x + superview.position.x, buttonPoint.y + superview.position.y);
            }
            superview = superview.superlayer;
        }
        buttonPoint = [[controller view]  convertPoint:buttonPoint toView:[[[controller view] superview] superview]];
        buttonPoint = NSMakePoint(buttonPoint.x, [[[controller view] superview] superview].frame.size.height - buttonPoint.y - 10);

        attachedWindow = [[MAAttachedWindow alloc] initWithView:[controller attachedView] 
                                                attachedToPoint:buttonPoint 
                                                       inWindow:[[controller view] window] 
                                                         onSide:side 
                                                     atDistance:0];
        [attachedWindow setBorderColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
    //    [textField setTextColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0]];
        [attachedWindow setBackgroundColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.8]];
        [attachedWindow setViewMargin:2.0f];
        [attachedWindow setBorderWidth:5.0f];
        [attachedWindow setCornerRadius:5.0f];
        [attachedWindow setHasArrow:YES];
        [attachedWindow setDrawsRoundCornerBesideArrow:YES];
        [attachedWindow setArrowBaseWidth:10.0f];
        [attachedWindow setArrowHeight:10.0f];
        
        [[[controller attachedView] name] setStringValue:[concert name]];
        
        [[[controller attachedView] likeButton] setState:0];
        [[[controller attachedView] dislikeButton] setState:0];

        if(concert.rating == 1){
            [[[controller attachedView] likeButton] setState:1];
        }
        if(concert.rating == -1){
            [[[controller attachedView] dislikeButton] setState:1];
        }

        [[controller attachedView] setObject:concert];

        NSString * stage;
        switch (concert.scene) {
            case 0:
                stage = @"Pavilion";
                break;                
            case 1:
                stage= @"Cosmopol";
                break;     
            case 2:
                stage = @"Odeon";
                break;     
            case 3:
                stage = @"Orange";
                break;     
            case 4:
                stage = @"Gloria";
                break;     
            case 5:
                stage = @"Arena";
                break;     
            default:
                break;
        }

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString * day = @"";
        switch (concert.day) {
            case 0:
                day = @"Thur.";
                break;
            case 1:
                day = @"Fri.";
                break;
            case 2:
                day = @"Sat.";
                break;
            case 3:
                day = @"Sun.";
                break;
                
            default:
                break;
        }
        
        [[[controller attachedView] place] setStringValue:
                 [NSString stringWithFormat:@"(%@) %@ %@\n%@",concert.country, day, [dateFormatter stringFromDate:concert.date],stage] ];

        [[[[[controller attachedView] description] textStorage] mutableString] setString:[NSString stringWithFormat:@"\n%@",concert.longdescription]];
        [[[controller attachedView] description] setTextColor:[NSColor whiteColor]];
        
        if(concert.image == nil){
            concert.image = [[NSImage alloc] initWithContentsOfURL:concert.imageUrl];
        }
        [[[controller attachedView] image] setImage:concert.image];
        
        [[[controller view] window] addChildWindow:attachedWindow ordered:NSWindowAbove];
    } else {
        [soundCloud stop];
        self.shadowRadius = 0;
        self.shadowOpacity = 0.0;
        
        self.borderColor = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0.8);
        [[[controller view] window] removeChildWindow:attachedWindow];
        [attachedWindow orderOut:self];
        [attachedWindow release];
        attachedWindow = nil;
    }
    



}

-(CALayer *)hitTest:(CGPoint)p{
    if([super hitTest:p]){
        [self mouseDown];
    }
    return [super hitTest:p];
}

@end
