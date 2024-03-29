//
//  CalculatorBrain.h
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 9/12/12.
//  Copyright (c) 2012 Evgenii Neumerzhitckii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVariableOrOperation:(NSString *)variable;
- (double)performOperation:(NSString *)operation;
- (void)removeTopFromStack;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
      usingVariables:(NSDictionary*) variableValues;
+ (NSString*)descriptionOfProgram:(id)program;
+ (NSSet*)variablesUsedInProgram:(id)program;

@end
 