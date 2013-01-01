//
//  AxesDrawer.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AxesDrawer : NSObject

+ (void)drawAxesInRect:(CGRect)bounds
         originAtPoint:(CGPoint)axisOrigin
                 scale:(CGFloat)pointsPerUnit;

+ (float)convertToAxesCoordinates:(int) viewValue
                           atOrigin:(float)origin
                          withScale:(float)scale;

+ (int)convertToViewCoordinates:(float)axesValue
                        atOrigin:(float)origin
                       withScale:(float)scale;

@end