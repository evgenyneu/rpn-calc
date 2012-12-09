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
        result = [self popOperand] / [self popOperand];
    }
    
    [self pushOperand:result];
    
    return result; 
}
 
@end
