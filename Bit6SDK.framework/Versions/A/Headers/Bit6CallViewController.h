//
//  Bit6CallViewController.h
//  Bit6
//
//  Created by Carlos Thurber on 01/08/15.
//  Copyright (c) 2015 Voxofon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bit6CallController.h"

/*! Easy to extend view controller to use during a call. */
@interface Bit6CallViewController : UIViewController <Bit6CallControllerDelegate>

/*! callController reference to the <Bit6CallController> to work with */
@property (nonatomic, strong) Bit6CallController *callController;

@end
