//
//  GraphView.m
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 31/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
#define DEFAULT_SCALE 50.0
#define GRAPH_TITLE_FONT_SIZE 12.0
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint originRelativeToCenter;
@end

@implementation GraphView

@synthesize originRelativeToCenter = _originRelativeToCenter;
@synthesize scale = _scale;

- (CGPoint) origin {
    CGPoint centerOrigin = [self originRelativeToCenter];
    return CGPointMake(centerOrigin.x + self.bounds.size.width / 2.0,
                       centerOrigin.y + self.bounds.size.height / 2.0);
}

- (void)setOrigin:(CGPoint)origin {
    [self setOriginRelativeToCenter:CGPointMake(origin.x - self.bounds.size.width / 2.0,
                                                origin.y - self.bounds.size.height / 2.0)];
}

- (CGPoint) originRelativeToCenter {
    if (!_originRelativeToCenter.x) {
        _originRelativeToCenter = CGPointMake(0.0, 0.0);
    }
    return _originRelativeToCenter;
}

- (void) setOriginRelativeToCenter:(CGPoint)originRelativeToCenter {
    if (!CGPointEqualToPoint(_originRelativeToCenter, originRelativeToCenter)) {
        _originRelativeToCenter = originRelativeToCenter;
        [self setNeedsDisplay];
    }
}

- (CGFloat) scale {
    if (!_scale) {
        _scale = DEFAULT_SCALE;
    }
    return _scale;
}

- (void)setScale:(CGFloat)scale {
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        gesture.state == UIGestureRecognizerStateEnded) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self];
        translation.x += self.origin.x;
        translation.y += self.origin.y;
        self.origin = translation;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)trippleTap:(UITapGestureRecognizer *)gesture {
    self.origin = [gesture locationInView:self];
}

- (void)drawGraphTitleBackground:(CGContextRef)context :(CGRect)rect {
    CGContextSaveGState(context);
    rect.origin.x -= 1;
    rect.size.height += 2;
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
}

- (void)drawProgramDescription {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    UIFont *font = [UIFont systemFontOfSize:GRAPH_TITLE_FONT_SIZE];
    NSString *textToDraw = [self.dataSource graphTitle];
    CGRect textRect;
    textRect.size = [textToDraw sizeWithFont:font];
    textRect.origin = CGPointMake(self.bounds.size.width - textRect.size.width - 10.0, 9.0);
    
    
    [self drawGraphTitleBackground:context :textRect];
    [textToDraw drawAtPoint:textRect.origin withFont:font];
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    for (float xPixel=0; xPixel < self.bounds.size.width * self.contentScaleFactor; xPixel++) {
        float xPoint = xPixel / self.contentScaleFactor;
        float x = [AxesDrawer convertToAxesCoordinates:xPoint atOrigin:self.origin.x withScale:self.scale];
        float y = - [self.dataSource calcYCoordinate:x];
        float yPoint = [AxesDrawer convertToViewCoordinates:y atOrigin:self.origin.y withScale:self.scale];
        if (!xPixel) {
            CGContextMoveToPoint(context, xPoint, yPoint);
        } else {
            CGContextAddLineToPoint(context, xPoint, yPoint);
        }
    }
    CGContextStrokePath(context);
    [self drawProgramDescription];
}

@end
