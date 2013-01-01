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
@end

@implementation GraphViewController

- (void)setProgram:(id)program {
    if (_program != program) {
        _program = program;
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
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithFloat:x], @"x", nil];
    return [CalculatorBrain runProgram:self.program usingVariables:variables];
}

@end
