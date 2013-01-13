//
//  GraphViewController.m
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 31/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController() <GraphDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, strong) NSMutableDictionary *coordinatesCache;
@property (nonatomic, strong) UIBarButtonItem  *splitViewButtonItem;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation GraphViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc {

    barButtonItem.title = @"Calculator";
    self.splitViewButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.splitViewButtonItem = nil;
}

- (void)setSplitViewButtonItem:(UIBarButtonItem *)splitViewButtonItem {
    if (_splitViewButtonItem != splitViewButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewButtonItem) [toolbarItems removeObject:_splitViewButtonItem];
        if (splitViewButtonItem) [toolbarItems insertObject:splitViewButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewButtonItem = splitViewButtonItem;
    }
}

- (NSMutableDictionary *)coordinatesCache {
    if (!_coordinatesCache) _coordinatesCache = [[NSMutableDictionary alloc] init];
    return _coordinatesCache;
}

- (void)setProgram:(id)program {
    if (_program != program) {
        _program = program;
        self.coordinatesCache = nil;
        [self.graphView setNeedsDisplay];
    }
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *trippleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(trippleTap:)];
    [trippleTapGesture setNumberOfTapsRequired:3];
    [self.graphView addGestureRecognizer:trippleTapGesture];
    self.graphView.dataSource = self;
}

- (float)calcYCoordinate:(float)x{
    NSString *xKeyName = [NSString stringWithFormat:@"%f", x];
    NSNumber *yNumber = [self.coordinatesCache valueForKey:xKeyName];
    if (!yNumber) {
        NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:x], @"x", nil];
        float y = [CalculatorBrain runProgram:self.program usingVariables:variables];
        yNumber = [NSNumber numberWithFloat:y];
        [self.coordinatesCache setValue:yNumber forKey:xKeyName];
    }
    return [yNumber floatValue];
}

- (NSString*)graphTitle {
    return [CalculatorBrain descriptionOfProgram:self.program];
}

@end
