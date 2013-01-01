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
#define DEFAULT_SCALE 100.0
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
    for (int xView=0; xView<self.bounds.size.width; xView++) {
        float x = [AxesDrawer convertToAxesCoordinates:xView atOrigin:self.origin.x withScale:self.scale];
        float y = sin(x);
        int yView = [AxesDrawer convertToViewCoordinates:y atOrigin:self.origin.y withScale:self.scale];
        NSLog(@"%f %f %i %i",x, y, xView, yView);
    }
    CGContextStrokePath(context);
}

@end
