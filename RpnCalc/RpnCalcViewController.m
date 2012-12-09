//
//  RpnCalcViewController.m
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 9/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import "RpnCalcViewController.h"

@interface RpnCalcViewController()

@property (nonatomic) BOOL  userIsEnteringANumber;

@end

@implementation RpnCalcViewController

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [ sender currentTitle];
    if (self.userIsEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
}

@end
