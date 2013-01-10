//
//  SKCalculatorBrain.h
//  Calculator
//
//  Created by Karl on 12-12-21.
//  Copyright (c) 2012 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKCalculatorBrain : NSObject

- (void)enterOperand:(double)operand;
- (void)enterVariable:(NSString *)variable;
- (void)enterOperation:(NSString *)operation;
- (void)clearHistory;
- (double)performOperation:(NSString *)operation;

@property (nonatomic, readonly) id program;

+ (double)runProgram:(id)program;
//pop the top thing off the stack. 1) if the top thing is a number, just return it; 2) if the top thing is an operation, then evaluate it with the next top thing.

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

+ (NSString *)descriptionOfProgram:(id)program;
//getter for the program will supply with the program
+ (NSSet *)variableUsedInProgram:(id)program;

@end
