//
//  SKCalculatorBrain.m
//  Calculator
//
//  Created by Karl on 12-12-21.
//  Copyright (c) 2012 Karl. All rights reserved.
//

#import "SKCalculatorBrain.h"

@interface SKCalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation SKCalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)operandStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)setOperandStack:(NSMutableArray *)anArray {
    _programStack = anArray;
}

- (void)pushOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void)enterVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [SKCalculatorBrain runProgram:self.programStack];
    //popOperand is gone now.
}

- (id)program {
    //since the property is readonly, only the getter method is needed;
    //we're making a copy of it, because we can't just go about handing out our internal state.
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    return @"Implement this in Assignment 2";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program {
    //always do introspection when using an argument of type id, because god knows what may be passed on to this method, and we do not want to crash our app by passing an argument that the method can't handle.
    NSMutableArray *stack; //automatically assigned 0
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    } // the array has to be mutable, so that we can munch on it and the recursion has an end.
    
    //I need a method that pops the top thing off the stack
    return [self popOperandOffStack:stack];
}

- (void)clearHistory {
    [self.operandStack removeAllObjects];
}

@end
