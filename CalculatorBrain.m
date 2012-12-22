//
//  CalculatorBrain.m
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 9/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import "CalculatorBrain.h"

typedef enum {
    stackUnknownElement,                // 0
    stackOperationWithTwoOperands,      // 1
    stackOperationWithSingleOperand,    // 2
    stackOperationWithNoOperands,       // 3
    stackValue,                         // 4
    stackVariable                       // 5
} StackElementType;

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

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([self getStackElementType:topOfStack] == stackValue) {
        result = [topOfStack doubleValue]; 
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
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

+ (StackElementType)getStackElementType:(id)stackElement {
    if ([stackElement isKindOfClass:[NSNumber class]]) return stackValue;
    if (![stackElement isKindOfClass:[NSString class]]) return stackUnknownElement;
    
    NSSet *operationsWithTwoOperands = [NSSet setWithObjects:@"+", @"−", @"×",@"÷", nil];
    NSSet *operationsWithSingleOperand = [NSSet setWithObjects:@"√", @"sin", @"cos",@"±", nil];
    NSSet *operationsWithNoOperands = [NSSet setWithObjects:@"π", nil];
    
    if ([operationsWithTwoOperands containsObject:stackElement]) return stackOperationWithTwoOperands;
         
    if ([operationsWithSingleOperand containsObject:stackElement]) return stackOperationWithSingleOperand;
         
    if ([operationsWithNoOperands containsObject:stackElement]) return stackOperationWithNoOperands;
    
    return stackVariable;
}

+ (double)runProgram:(id)program {
    return [self runProgram:program usingVariables:NULL];
}

+ (NSMutableArray*)convertProgramToStack:(id)program{
    if ([program isKindOfClass:[NSArray class]]) {
        return [program mutableCopy];
    }
    return nil;
}

+ (void)replaceVariablesWithValues:(id)program
                    usingVariables:(NSDictionary*)variableValues {
    NSMutableArray *stack = [self convertProgramToStack:program];
    NSSet *variablesUsed = [self variablesUsedInProgram:program];
    for (int i=0; i<stack.count; i++) {
        id name = [stack objectAtIndex:i];
        if ([variablesUsed containsObject:name]) {
            NSNumber *variableValue = [variableValues objectForKey:name];
            if (!variableValue) variableValue = [NSNumber numberWithDouble:0];
            [stack replaceObjectAtIndex:i withObject:variableValue];
        }
    }
}

+ (double)runProgram:(id)program
      usingVariables:(NSDictionary*)variableValues {
    NSMutableArray *stack = [self convertProgramToStack:program];
    [self replaceVariablesWithValues:program usingVariables:variableValues];
    return [self popOperandOffStack:stack];
}

+ (NSSet*)variablesUsedInProgram:(id)program {
    if ([program isKindOfClass:[NSArray class]]) {
        NSMutableSet *variables = [[NSMutableSet alloc] init];
        for (id element in (NSArray*)program) {
            if ([self getStackElementType:element] == stackVariable) {
                [variables addObject:element];
            }
        }
        if ([variables count]) return [variables copy];
    }
    return nil;
}

+ (NSString *)surroundWithParentheses:(NSString*)string {
    if ([string rangeOfString:@" + "].location != NSNotFound ||
        [string rangeOfString:@" − "].location != NSNotFound) {
        string = [NSString stringWithFormat:@"(%@)", string];
    }
    return string;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSString *description;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    switch ([self getStackElementType:topOfStack]) {
        case stackValue:
        case stackOperationWithNoOperands:
        case stackVariable: {
            description = [NSString stringWithFormat:@"%@", topOfStack];
            break;
        }
        case stackOperationWithSingleOperand: {
            description = [NSString stringWithFormat:@"%@(%@)", topOfStack, [self descriptionOfTopOfStack:stack]];
            break;
        }
        case stackOperationWithTwoOperands: {
            NSString *operand1 = [self descriptionOfTopOfStack:stack];
            NSString *operand2 = [self descriptionOfTopOfStack:stack];
            
            NSSet *precedenceOperators = [NSSet setWithObjects:@"×",@"÷", nil];
            if ([precedenceOperators containsObject:topOfStack]) {
                operand1 = [self surroundWithParentheses:operand1];
                operand2 = [self surroundWithParentheses:operand2];
            }

            description = [NSString stringWithFormat:@"%@ %@ %@", operand2, topOfStack, operand1];
            break;
        }
        default:
            break;
    }
    if (!description) description = @"0";
    return description;
}

+ (NSString*)descriptionOfProgram:(id)program {
    NSMutableArray *stack = [self convertProgramToStack:program];
    return [self descriptionOfTopOfStack:stack];
}

@end
