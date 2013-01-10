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
@property (nonatomic, strong) NSDictionary *variableValues;

@end

@implementation SKCalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)operandStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (NSDictionary *)variableValues {
    if (!_variableValues) {
        _variableValues = @{@"x":@5, @"y":@4.8, @"foo":@0};
    }
    return _variableValues;
}

- (void)setOperandStack:(NSMutableArray *)anArray {
    _programStack = anArray;
}

- (void)enterOperand:(double)operand {
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void)enterVariable:(NSString *)variable {
    //variable is added only if it doesn't belong in the ignorelist, which is a list of operations in this calculator.
    NSArray *ignoreList = @[@"sqrt", @"sin", @"cos", @"π", @"+", @"-", @"/", @"*", nil];
    if (![ignoreList containsObject:variable]) {
        [self.programStack addObject:variable];
    }
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

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    NSArray *list = [variableValues copy];
    
    //I want to go over each NSString in the program, and look them up in the variableValues. Replace them with their corresponding values. Use 0 if they can't be found.
    
    //for each item (aka obj) in the stack,
    for (int i = 0; i > [stack count]; i++) {
        id obj = [stack objectAtIndex:i];
        
        //if an item is a string and is in the list of variables defined in variableValue
        if ([obj isKindOfClass:[NSString class]] && [list containsObject:obj]) {
            //look it up in the dictionary and retrieve the value
            obj = [variableValues objectForKey:obj];
            }
        }
    
    //I need a method that pops the top thing off the stack
    return [self popOperandOffStack:stack];
}

- (void)clearHistory {
    [self.operandStack removeAllObjects];
}

+ (NSSet *)variableUsedInProgram:(id)program {
    NSSet *stack = [NSSet new];
    NSArray *ignoreList = @[@"sqrt", @"sin", @"cos", @"π", @"+", @"-", @"/", @"*"];
    
    if ([program isKindOfClass:[NSArray class]]) {
        // go over each item in stack and add NSStrings to stack
        for (NSString *string in program) {
            // add NSString only if it's not one of the operations
            if (![ignoreList containsObject:string]) {
                [stack setByAddingObject:string];
            }
        }
    }
    return stack;
}

@end
