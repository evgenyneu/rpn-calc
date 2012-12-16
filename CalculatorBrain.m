//
//  CalculatorBrain.m
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 9/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

- (NSMutableArray *) operandStack {
    if (!_operandStack) _operandStack = [[NSMutableArray alloc] init]; 
    return _operandStack;
}

- (void)pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return  [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation {
    double result = 0;
    
    if ([@"+" isEqualToString:operation]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"−" isEqualToString:operation]) {
        result = [self popOperand] - [self popOperand];
    } else if ([@"×" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([@"÷" isEqualToString:operation]) {
        double operand = [self popOperand];
        result = [self popOperand] / operand;
    } else if ([@"√" isEqualToString:operation]) {
        result = sqrt([self popOperand]);
    } else if ([@"sin" isEqualToString:operation]) {
        result = sin([self popOperand]);
    } else if ([@"cos" isEqualToString:operation]) {
        result = cos([self popOperand]);
    } else if ([@"π" isEqualToString:operation]) {
        result = M_PI;
    }
    
    [self pushOperand:result];
    
    return result; 
}
 
@end
