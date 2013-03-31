//
//  CalculatorProgramsTableViewController.h
//  RpnCalc
//
//  Created by Evgenii Neumerzhitckii on 31/03/13.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorProgramsTableViewController;

@protocol CalculatorProgramsTableViewControllerDelegate
@optional 
- (void) calculatorProgramsTableViewController: (CalculatorProgramsTableViewController*) sender
                                 chooseProgram: (id)program;
- (void) calculatorProgramsTableViewController: (CalculatorProgramsTableViewController*) sender
                                deletedProgramAtIndex:(NSUInteger)index;
@end

@interface CalculatorProgramsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *programs;
@property (nonatomic, weak) id <CalculatorProgramsTableViewControllerDelegate> delegate;

@end
