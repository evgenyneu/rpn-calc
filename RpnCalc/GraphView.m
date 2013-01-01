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
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@end

@implementation GraphView

- (CGPoint) origin {
    if (!_origin.x) {
        _origin = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    return _origin;
}

- (CGFloat) scale {
    if (!_scale) {
        _scale = DEFAULT_SCALE;
    }
    return _scale;
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    for (float xPixel=0; xPixel < self.bounds.size.width * self.contentScaleFactor; xPixel++) {
        float xPoint = xPixel / self.contentScaleFactor;
        float x = [AxesDrawer convertToAxesCoordinates:xPoint atOrigin:self.origin.x withScale:self.scale];
        float y = [self.dataSource calcYCoordinate:x];
        float yPoint = [AxesDrawer convertToViewCoordinates:y atOrigin:self.origin.y withScale:self.scale];
        if (!xPixel) {
            CGContextMoveToPoint(context, xPoint, yPoint);
        } else {
            CGContextAddLineToPoint(context, xPoint, yPoint);
        }
        NSLog(@"%f %f %f %f",x, y, xPoint, yPoint);
    }
    CGContextStrokePath(context);
}

@end
