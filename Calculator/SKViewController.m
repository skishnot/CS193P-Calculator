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

- (NSDictionary *)testVariableValues {
    if (!_testVariableValues) {
        _testVariableValues = @{@"x":@5, @"y":@4.8, @"foo":@0};
    }
    return _testVariableValues;
}

- (void)updateVariableDisplay {
    NSSet *set = [SKCalculatorBrain variableUsedInProgram:self.brain.program];
    NSString *string = @"Variables: ";
    // go through items in the set and display them
    for (NSString* key in set) {
        double val = [[self.testVariableValues objectForKey:key] doubleValue];
        string = [string stringByAppendingFormat:@"%@=%g ", key, val];
    }
    self.variableDisplay.text = string;
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
    [self.brain enterOperand:[self.display.text doubleValue]];
    self.stackDisplay.text = [SKCalculatorBrain descriptionOfProgram:self.brain.program];
    self.display.text = @"0";
    [self updateVariableDisplay];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed {
    [self.brain clearHistory];
    self.stackDisplay.text = [SKCalculatorBrain descriptionOfProgram:self.brain.program];
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
    } else {
        NSRange range = [self.display.text rangeOfString:@"-"];
        if (range.location == NSNotFound) {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
            [self enterPressed];
        } else {
            self.display.text = [self.display.text substringFromIndex:1];
            [self enterPressed];
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self.brain enterOperation:sender.currentTitle];
    self.stackDisplay.text = [SKCalculatorBrain descriptionOfProgram:self.brain.program];
    double result = [SKCalculatorBrain runProgram:[self.brain program] usingVariableValues:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)testPressed:(id)sender {
    if ([sender currentTitle] == @"Test 1") {
        <#statements#>
    } else if ([sender currentTitle] == @"Test 2") {
        
    } else if ([sender currentTitle] == @"Test 3") {
        
    }
}


@end
