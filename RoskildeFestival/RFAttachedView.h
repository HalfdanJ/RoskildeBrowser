#import <Cocoa/Cocoa.h>

@class RFConcertObject;

@interface RFAttachedView : NSView {
    NSImageView *image;
    NSTextView *description;
    NSTextField *name;
    NSTextField *place;
    RFConcertObject * object;
    
    NSButton * likeButton;
    NSButton * dislikeButton;
}
@property (assign) IBOutlet NSTextField *place;
@property (assign) IBOutlet NSTextField *name;

@property (assign) IBOutlet NSImageView *image;
@property (assign) IBOutlet NSTextView *description;

@property (assign) IBOutlet NSButton *likeButton;
@property (assign) IBOutlet NSButton *dislikeButton;
@property (assign) RFConcertObject * object;

-(IBAction)dislike:(id)sender;
-(IBAction)like:(id)sender;
@end
