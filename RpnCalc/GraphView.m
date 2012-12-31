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
@end

@implementation GraphView

- (void)drawRect:(CGRect)rect
{
    CGPoint axesOrigin = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:axesOrigin scale:10.0];
}

@end
