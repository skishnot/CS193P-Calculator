//
//  SKViewController.h
//  Calculator
//
//  Created by Karl on 12-12-17.
//  Copyright (c) 2012 Karl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *stackDisplay;
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;
@property (weak, nonatomic) NSDictionary *testVariableValues;

@end
