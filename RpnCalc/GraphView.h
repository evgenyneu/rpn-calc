//
//  GraphView.h
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 31/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphDataSource <NSObject>
- (float)calcYCoordinate:(float)x;
- (NSString*)graphTitle;
@end

@interface GraphView : UIView

@property (nonatomic, weak) id<GraphDataSource> dataSource;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)trippleTap:(UITapGestureRecognizer *)gesture;

@end
