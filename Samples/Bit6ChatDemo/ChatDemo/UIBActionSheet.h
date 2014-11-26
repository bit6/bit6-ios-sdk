//
//  UIBActionSheet.h
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 10/10/13.
//  Copyright (c) 2013 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ActionSheetDismissedHandler) (NSInteger selectedIndex, BOOL didCancel, BOOL didDestruct);

@interface UIBActionSheet : NSObject

- (id)initWithTitle:(NSString *)aTitle cancelButtonTitle:(NSString *)aCancelTitle  destructiveButtonTitle:(NSString *)aDestructiveTitle otherButtonTitles:(NSString *)otherTitles,...NS_REQUIRES_NIL_TERMINATION;

@property(nonatomic) UIActionSheetStyle actionSheetStyle;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated dismissHandler:(ActionSheetDismissedHandler)handler;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated dismissHandler:(ActionSheetDismissedHandler)handler;
- (void)showInView:(UIView *)view dismissHandler:(ActionSheetDismissedHandler)handler;

@end