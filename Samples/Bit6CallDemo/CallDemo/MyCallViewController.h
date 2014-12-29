//
//  MyCallViewController.h
//  FullDemo
//
//  Created by Carlos Thurber on 12/01/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCallViewController : UIViewController <Bit6CallControllerDelegate>

- (instancetype)initWithCallController:(Bit6CallController*)callController;

@end