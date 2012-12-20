//
//  CalculatorBrain.m
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 9/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

- (NSMutableArray *) programStack {
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
} 

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id)program {
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    return @"Implement this in assignment @"; 
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue]; 
    }
    else  if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack; 
        if ([@"+" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"−" isEqualToString:operation]) {
            double operand = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - operand;
        } else if ([@"×" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([@"÷" isEqualToString:operation]) {
            double operand = [self popOperandOffStack:stack];
            if (operand == 0) {
                result = 0;
            } else {
                result = [self popOperandOffStack:stack] / operand;
            }
        } else if ([@"√" isEqualToString:operation]) {
            double operand = [self popOperandOffStack:stack];
            if (operand < 0) {
                result = 0;
            } else {
                result = sqrt(operand);
            }
        } else if ([@"sin" isEqualToString:operation]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([@"cos" isEqualToString:operation]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([@"π" isEqualToString:operation]) {
            result = M_PI;
        } else if ([@"±" isEqualToString:operation]) {
            result = -1 * [self popOperandOffStack:stack];
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
}   

@end
