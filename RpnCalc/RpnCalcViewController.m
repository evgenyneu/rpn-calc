//
//  RpnCalcViewController.m
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 9/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import "RpnCalcViewController.h"

@implementation RpnCalcViewController

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    NSLog(@"Digit presset = %@", digit)
}

@end
