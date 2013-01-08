//
//  SKViewController.m
//  Calculator
//
//  Created by Karl on 12-12-17.
//  Copyright (c) 2012 Karl. All rights reserved.
//

#import "SKViewController.h"
#import "SKCalculatorBrain.h"

@interface SKViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) SKCalculatorBrain *brain;

@end

@implementation SKViewController

- (SKCalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[SKCalculatorBrain alloc] init];
    }
    return _brain;
}

- (void)clearParameter {
    self.userIsInTheMiddleOfEnteringANumber = NO;
//    self.display.text = @"0";
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)dotPressed {
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    NSString *digit = [@" " stringByAppendingString:self.display.text];
        // extra touch to prevent culttering stackDisplay area
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:digit];
    [self clearParameter];
}

- (IBAction)clearPressed {
    [self.brain performOperation:@"Clear"];
    self.stackDisplay.text = @"History: ";
    [self clearParameter];
}

- (IBAction)deletePressed {
    if ([self.display.text length] == 1) {
        [self clearParameter];
    } else if ([self.display.text length] > 1) {
            //user has to be in the middle of entering a number to be able to delete characters
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
    }
}

- (IBAction)changeSign {
    NSRange range = [self.display.text rangeOfString:@"-"];
    if (range.location == NSNotFound) {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
    } else {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            self.display.text = [self.display.text substringFromIndex:1];
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %@ =", operation]];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}



@end
