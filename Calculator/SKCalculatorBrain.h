//
//  SKCalculatorBrain.h
//  Calculator
//
//  Created by Karl on 12-12-21.
//  Copyright (c) 2012 Karl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKCalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)clearHistory;
- (double)performOperation:(NSString *)operation;

@end
