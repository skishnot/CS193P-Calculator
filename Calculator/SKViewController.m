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
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:[@" " stringByAppendingString:self.display.text]];
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed {
    [self.brain performOperation:@"Clear"];
    self.stackDisplay.text = @"History: ";
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)deletePressed {
    //in case number is over 2 digits, delete the last char
    if ([self.display.text length] > 2) {
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
    }
    
    //in case number is exactly 2 digits, check if +/- sign is there, then proceed to change the sign first
    else if ([self.display.text length] == 2) {
        NSRange range = [self.display.text rangeOfString:@"-"];
        if (range.location != NSNotFound) {
            self.display.text = [self.display.text substringFromIndex:1];
        }
        
        //if not, just delete the last char as usual
        else {
            self.display.text = [self.display.text substringToIndex:1];
        }
    }
    
    //in case the number is 1 digit long, just turn it to 0 and reset userIsInTheMiddleOfEnteringANumber
    else if ([self.display.text length] == 1) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)changeSign {
    // +/- button is enabled only when the user is in the middle of entering a number
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSRange range = [self.display.text rangeOfString:@"-"];
        if (range.location == NSNotFound) {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        } else {
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
