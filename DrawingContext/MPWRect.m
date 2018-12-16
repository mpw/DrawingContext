/* MPWRect.m Copyright (c) 1998-2017 by Marcel Weiher, All Rights Reserved.
*/


#import "MPWRect.h"
#import "MPWPoint.h"
#import "AccessorMacros.h"

@implementation MPWRect
/*"
   An object level rectangle abstraction, primarily for use of points with WebScript.
"*/


-initWithRect:(NSRect)aRect
{
    self = [super init];
    [self setRect:aRect];
    return self;
}

+rectWithRect:(NSRect)aRect
{
    return AUTORELEASE([[self alloc] initWithRect:aRect]);
}

-(void)setOrigin:aPoint
{
	_rect.origin=[aPoint point];
}

-(void)setMpwSize:aPoint
{
	_rect.size=[aPoint asSize];
}

-(double)x
{
    return _rect.origin.x;
}

-(double)y
{
    return _rect.origin.y;
}

-(double)width
{
    return _rect.size.width;
}

-(double)height
{
    return _rect.size.height;
}

-origin
{
    return [MPWPoint pointWithNSPoint:_rect.origin];
}

-mpwSize
{
    return [MPWPoint pointWithNSPoint:(NSPoint){
        _rect.size.width,_rect.size.height
    }];
}

-size
{
    return [self mpwSize];
}

-(NSUInteger)count
{
    return 4;
}

-(void)getReals:(float*)reals length:(long)len
{
    if (len>=4) {
        reals[0]=_rect.origin.x;
        reals[1]=_rect.origin.y;
        reals[2]=_rect.size.width;
        reals[3]=_rect.size.height;
    }
}


+rectWithNSRect:(NSRect)aRect
{
    return AUTORELEASE([[self alloc] initWithRect:aRect]);
}
#if ! TARGET_OS_IPHONE

+rectWithNSString:(NSString*)string
{
    return [self rectWithNSRect:NSRectFromString(string)];
}

-description
{
    return NSStringFromRect( [self rect] );
}
#else
-description
{
    return [NSString stringWithFormat:@"%@:%p: origin=%@ extent: %@",[self class],self,[self origin],[self mpwSize
                                                                                                      ]];
}

#endif

-(double)midX
{
    return (_rect.origin.x * 2 + _rect.size.width)/2.0;
}

-(double)midY
{
    return (_rect.origin.y * 2 + _rect.size.height)/2.0;
}

-(NSPoint)center
{
    return NSMakePoint( [self midX], [self midY] );
}

-(MPWRect*)inset:(double)xInset :(double)yInset
{
    return [[self  class] rectWithRect:NSInsetRect( _rect, xInset, yInset )];
}

-(MPWRect*)inset:anObject
{
    float x=0,y=0;
    if ( [anObject respondsToSelector:@selector(x)] && [anObject respondsToSelector:@selector(y)] ) {
        x=[(MPWPoint*)anObject x];
        y=[(MPWPoint*)anObject y];
    } else {
        x=[anObject doubleValue];
        y=x;
    }
    return [self inset:x :y];
}

-(NSRect)rectValue
{
    return _rect;
}

@end

@implementation NSString(rectCreation)

-asRect
{
    return [MPWRect rectWithNSString:self];
}

-(NSRect)rectValue
{
    return [[self asRect] rectValue];
}

@end

#import "DebugMacros.h"

@implementation MPWRect(testing)

+(MPWRect*)_testA { return [self rectWithRect:NSMakeRect( 10,15,30,105)]; }
+(MPWRect*)_testB { return [self rectWithRect:NSMakeRect( 100,20,130,30)]; }

+(void)testMid
{
    MPWRect *a=[self _testA];
    FLOATEXPECT([a midX], 25.0, @"a midX");
    FLOATEXPECT([a midY], 67.5, @"a midY");
    MPWRect *b=[self _testB];
    FLOATEXPECT([b midX], 165.0, @"b midX");
    FLOATEXPECT([b midY], 35.0, @"b midY");
    
}

+(void)testXYWidthHeight
{
    MPWRect *a=[self _testA];
    FLOATEXPECT([a x], 10.0, @"a x");
    FLOATEXPECT([a y], 15.0, @"a y");
    FLOATEXPECT([a width], 30.0, @"a width");
    FLOATEXPECT([a height], 105.0, @"a height");
    MPWRect *b=[self _testB];
    FLOATEXPECT([b x], 100.0, @"b x");
    FLOATEXPECT([b y], 20.0, @"b y");
    FLOATEXPECT([b width], 130.0, @"b width");
    FLOATEXPECT([b height], 30.0, @"b height");
    
}


+(void)testCenter
{
    MPWRect *a=[self _testA];
    NSPoint center=[a center];

    
    FLOATEXPECT(center.x , 25.0, @"a center.x");
    FLOATEXPECT(center.y , 67.5, @"a center.y");
    MPWRect *b=[self _testB];
    center=[b center];
    FLOATEXPECT(center.x , 165.0, @"b center.x");
    FLOATEXPECT(center.y , 35.0, @"b center.y");
    
}

+(void)testInset
{
    MPWRect *a=[self _testA];
    MPWRect *insetA=[a inset:5 :4];
    FLOATEXPECT([insetA x], 15.0, @"a x");
    FLOATEXPECT([insetA y], 19.0, @"a y");
    FLOATEXPECT([insetA width], 20.0, @"a width");
    FLOATEXPECT([insetA height], 97.0, @"a height");
    
}


+testSelectors
{
    return [NSArray arrayWithObjects:
            @"testMid",
            @"testXYWidthHeight",
            @"testCenter",
            @"testInset",
            nil];
}

@end
