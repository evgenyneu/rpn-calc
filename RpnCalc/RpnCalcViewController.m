//
//  RpnCalcViewController.m
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 9/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import "RpnCalcViewController.h"
#import "CalculatorBrain.h" 

@interface RpnCalcViewController()
@property (nonatomic) BOOL  userIsEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableArray *history;
@end

@implementation RpnCalcViewController

static NSUInteger const historySize = 10;

- (NSMutableArray*) history {
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (void)updateHistory:(NSString *) text {
    [self updateHistory:text:NO];
}

- (void)updateHistory:(NSString *) text:(BOOL) isOperation  {
    if (self.history.count == historySize) [self.history removeObjectAtIndex:0];
    [self.history addObject:text];
    self.historyLabel.text = [self.history componentsJoinedByString:@" "];
    if (isOperation) {
        self.historyLabel.text = [self.historyLabel.text stringByAppendingString:@" ="];
    }
}

- (CalculatorBrain*) brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain; 
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsEnteringANumber) {
        if ([digit isEqualToString:@"."] && [self.display.text rangeOfString:@"."].location != NSNotFound) {
            return;
        }
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        if ([digit isEqualToString:@"."]) digit = @"0.";
        self.display.text = digit;
        self.userIsEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsEnteringANumber = NO;
    [self updateHistory:self.display.text];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsEnteringANumber) [self enterPressed]; 
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    [self updateHistory:sender.currentTitle:YES];
}

- (IBAction)changeSignPressed:(UIButton *)sender {
    if (self.userIsEnteringANumber) {
        if ([self.display.text hasPrefix:@"-"]) {
            self.display.text = [self.display.text substringFromIndex: 1];
        } else {
            self.display.text = [NSString stringWithFormat:@"-%@", self.display.text];
        }
    } else {
        if (![self.display.text isEqualToString:@"0"]) {
            [self operationPressed:sender];
        }
    }
}

- (IBAction)clearPressed {
    self.brain = NULL;
    self.userIsEnteringANumber = NO;
    self.display.text = @"0";
    self.history = NULL;
    self.historyLabel.text = @"";
}

- (IBAction)backspacePressed {
    if (!self.userIsEnteringANumber) return;
    if (self.display.text.length > 0) {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        if (self.display.text.length == 0) {
            self.userIsEnteringANumber = NO;
            self.display.text = @"0";
        }
    }
}

@end
