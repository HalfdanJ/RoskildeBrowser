//
//  RFController.m
//  RoskildeFestival
//
//  Created by Jonas Jongejan on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFController.h"
#import "RFTopView.h"

@implementation RFController
@synthesize topview;
@synthesize view;
@synthesize attachedView, concertArray, soundcloud;

- (id)init
{
    self = [super init];
    if (self) {
        daysArray = [NSMutableArray array];

        //Add days to the concertarray
        concertArray = [NSMutableArray array];
        [concertArray addObject:[NSMutableArray array]]; //Thursday
        [concertArray addObject:[NSMutableArray array]]; //Friday
        [concertArray addObject:[NSMutableArray array]]; //Saturday
        [concertArray addObject:[NSMutableArray array]]; //Sunday
        
        //Add arrays for stages
        for(NSMutableArray * array in concertArray){
            for(int i=0;i<6;i++){
                [array addObject:[NSMutableArray array]];
            }
        }
        
        //Create the xml parser 
        rfParser = [[RFXMLParser alloc] init];
        [rfParser setDelegate:self];
        
        soundcloud = [[RFSoundCloud alloc] init];
    }
    
    return self;
}


-(void)awakeFromNib{
    [self setupHostView];    
    [rfParser startParsing];    
    
}

-(void) stop{
    for(int day=0;day<4;day++){
        for(NSMutableArray * stage in [concertArray objectAtIndex:day]){        
            for(RFConcertObject * concert in stage){   
                if(concert.layer.attachedWindow){
                    [concert.layer mouseDown];
                }
            }
        }
    }
}


-(void)mouseDown:(NSEvent *)theEvent{

}

//Called from parser when a concert is added
-(void) addConcert:(RFConcertObject*)concert{
    if(concert.day >= 0 && concert.date != nil){      
        [[[concertArray objectAtIndex:concert.day] objectAtIndex:concert.scene] addObject:concert];
    }
}

//Called from the parser when all concerts are added
-(void)finishedParsing{
    [self createDays];

}

//Setup the main layer
-(void)setupHostView {
    CALayer *layer = [CALayer layer]; 
    layer.bounds = NSMakeRect(0.0, 0.0, view.frame.size.width, view.frame.size.height);
    layer.geometryFlipped = YES;
//    layer.backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"bg"]];
    //layer.backgroundColor = [NSColor redColor];    
    [view setLayer:layer]; 
    [view setWantsLayer:YES];
    [view setAutoresizesSubviews:YES];
    
    
    CALayer * topLayer = [CALayer layer];
    topLayer.bounds = NSMakeRect(0.0, 0.0, topview.frame.size.width, topview.frame.size.height);
    topLayer.geometryFlipped = YES;
    [topview setLayer:topLayer]; 
    [topview setWantsLayer:YES];
}


//Create the layer that bondries the whole day
-(CALayer*) createDay{
    CALayer * layer = [CALayer layer];
    layer.borderColor = CGColorCreateGenericGray(0.0, 0.8);
    layer.bounds = CGRectMake(0, 0, view.frame.size.width -40, 300);
    layer.borderWidth = 1.0;
    layer.position = CGPointMake(30, 0);
    layer.autoresizingMask = kCALayerWidthSizable ;
    layer.backgroundColor = CGColorCreateGenericRGB(0, 0, 0, 0.4);
    layer.anchorPoint = CGPointMake(0, 0);
    layer.cornerRadius = 10;    
    layer.shadowOffset = CGSizeMake(0,0);
    layer.shadowOpacity = 1.0;

    return layer;
}

//Adds the text next to the day
-(void) addGuiToDay:(CALayer*)layer named:(NSString*)named{    
    CATextLayer * title = [CATextLayer layer];
    title.string = named;
    title.fontSize = 15;
    title.alignmentMode =  kCAAlignmentCenter;
    title.foregroundColor = CGColorCreateGenericGray(1.0, 0.9);
    title.shadowOffset = CGSizeMake(0,0);
    title.shadowOpacity = 1.0;
    title.bounds = CGRectMake(0, 0, layer.bounds.size.height, 20);
    //    title.backgroundColor = CGColorCreateGenericRGB(1.0, 0.0, 0.4, 0.3);
    title.position = CGPointMake(-8, layer.bounds.size.height*0.5);
    //    title.anchorPoint = CGPointMake(0, 0);
    title.transform = CATransform3DMakeRotation(-0.5*3.147, 0, 0, 1);
    
    [layer addSublayer:title];
}

//Adds all the content to a day
-(void) populateDayLayer:(CALayer*) layer day:(int) day{
    int i=0;
    
    //The width of the concerts and stages
    int w = (layer.bounds.size.width-15)/6;
    
    //Find the first and alst concert
    NSDate * firstDate = nil, *lastDate = nil;
    for(NSMutableArray * stage in [concertArray objectAtIndex:day]){
        for(RFConcertObject * concert in stage){
            if(firstDate == nil || [concert.date timeIntervalSinceDate:firstDate] < 0)
                firstDate = concert.date;            
            if(lastDate == nil || [concert.date timeIntervalSinceDate:lastDate] > 0)
                lastDate = concert.date;
        }
    }
        
    //Define the height of one hour
    int timeH = 20;
    
    //Find the height of the day
    NSTimeInterval timeBetween = [lastDate timeIntervalSinceDate:firstDate];
    int h = timeH*timeBetween / (60.0*60.0);

    //Set the day to that hight
    layer.bounds = CGRectMake(0, 0, layer.bounds.size.width, h+50);
    

    //Add the stages and its concerts
    for(NSMutableArray * stage in [concertArray objectAtIndex:day]){
        CALayer * stageLayer = [CALayer layer];
        stageLayer.bounds = CGRectMake(0, 0, w-10, layer.bounds.size.height);
        stageLayer.anchorPoint = CGPointMake(0, 0);
        stageLayer.position = CGPointMake(i*w, 0);
        
        
        for(RFConcertObject * concert in stage){
            //Create the concert layer
            RFConcertLayer * layer = [self createLayer:concert width:w-8];
            [concert setLayer:layer];
            [layer setController:self];
            
            //Position it correctly
            int y = timeH*[concert.date timeIntervalSinceDate:firstDate]/(60*60)+10;
            [stageLayer addSublayer:concert.layer];
            concert.layer.position = CGPointMake(4, y);
        }
        i++;
        
        [layer addSublayer:stageLayer];
    }

}

//Create the days layers, and its content
-(void) createDays{
    CALayer * parentLayer = [view layer];
    
    CALayer * thursday = [self createDay];
    thursday.position = CGPointMake(thursday.position.x, 30);
    [daysArray addObject:thursday];
    [parentLayer addSublayer:thursday];
    [self populateDayLayer:thursday day:0];
    [self addGuiToDay:thursday named:@"THURSDAY"];

    CALayer * friday = [self createDay];
    friday.position = CGPointMake(friday.position.x, thursday.position.y + thursday.bounds.size.height+20);
    [daysArray addObject:friday];
    [parentLayer addSublayer:friday];
    [self populateDayLayer:friday day:1];
    [self addGuiToDay:friday named:@"FRIDAY"];

    CALayer * saturday = [self createDay];
    saturday.position = CGPointMake(saturday.position.x, friday.position.y + friday.bounds.size.height+20);
    [daysArray addObject:saturday];
    [parentLayer addSublayer:saturday];
    [self populateDayLayer:saturday day:2];
    [self addGuiToDay:saturday named:@"SATURDAY"];

    CALayer * sunday = [self createDay];
    sunday.position = CGPointMake(sunday.position.x, saturday.position.y + saturday.bounds.size.height+20);
    [daysArray addObject:sunday];
    [parentLayer addSublayer:sunday];
    [self populateDayLayer:sunday day:3];
    [self addGuiToDay:sunday named:@"SUNDAY"];

    //Create the stage titles
    int w = (sunday.bounds.size.width-15)/6;
    
    for(int i=0;i<6;i++){
        CATextLayer * title = [CATextLayer layer];
        switch (i) {
            case 0:
                title.string = @"Pavilion";
                break;                
            case 1:
                title.string = @"Cosmopol";
                break;     
            case 2:
                title.string = @"Odeon";
                break;     
            case 3:
                title.string = @"Orange";
                break;     
            case 4:
                title.string = @"Gloria";
                break;     
            case 5:
                title.string = @"Arena";
                break;     
            default:
                break;
        }
        title.fontSize = 12;
        title.alignmentMode =  kCAAlignmentCenter;
        title.foregroundColor = CGColorCreateGenericGray(1.0, 0.9);
        title.bounds = CGRectMake(0, 0, w, 20);
        title.position = CGPointMake(w*i+sunday.position.x, 7);
        title.anchorPoint = CGPointMake(0, 0);
        title.shadowOffset = CGSizeMake(0,0);
        title.shadowOpacity = 1.0;

        [[topview layer] addSublayer:title];
    }
    
    
    [view  setFrameSize:NSMakeSize(view.frame.size.width, sunday.position.y+20 + sunday.bounds.size.height)];    
    [view display];
    [[view superview]  display];
      //  [view  setBoundsSize:NSMakeSize(view.frame.size.width, sunday.position.y+20 + sunday.bounds.size.height)];    
}



//Create a concert layer
-(RFConcertLayer*) createLayer:(RFConcertObject*)concert width:(int)width{
    RFConcertLayer *newLayer = [RFConcertLayer layer];

    newLayer.position = CGPointMake(0,0);
    newLayer.bounds = CGRectMake(0.0, 0.0, width, 30);
  //  newLayer.backgroundColor = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0.9); 
    
    newLayer.colors = [NSArray arrayWithObjects:
                            (id)CGColorCreateGenericGray(1.0, 0.9),
                            (id)CGColorCreateGenericGray(1.0, 0.7),
                            nil];
    newLayer.startPoint = CGPointMake(0, 0);
    newLayer.endPoint = CGPointMake(0, 1);
    
    newLayer.anchorPoint = CGPointMake(0, 0);
    newLayer.cornerRadius = 5;
    newLayer.borderColor = CGColorCreateGenericGray(0.0, 0.6);
    newLayer.borderWidth = 1;
//    newLayer.shadowOffset = CGSizeMake(0,0);
  //  newLayer.shadowOpacity = 1.0;
    
    CATextLayer * title = [CATextLayer layer];
    title.string = concert.name;
    title.fontSize = 10;
    title.alignmentMode =  kCAAlignmentCenter;
    title.foregroundColor = CGColorCreateGenericGray(0.0, 0.9);
    title.bounds = CGRectMake(0, 0, width-6, 20);
    title.position = CGPointMake(3, 6);
    title.anchorPoint = CGPointMake(0, 0);
    title.wrapped = YES;
        
    [newLayer addSublayer:title];

    
    return newLayer;
}

@end
