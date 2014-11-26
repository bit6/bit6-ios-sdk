//
//  UIBActionSheet.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 10/10/13.
//  Copyright (c) 2013 Bit6. All rights reserved.
//

#import "UIBActionSheet.h"

@interface UIBActionSheet () <UIActionSheetDelegate>

@property (strong, nonatomic) UIBActionSheet *strongActionSheetReference;
@property (copy) ActionSheetDismissedHandler activeDismissHandler;
@property (strong, nonatomic) UIActionSheet *activeActionSheet;

@end

@implementation UIBActionSheet

#pragma mark - Public (Initialization)

- (id)initWithTitle:(NSString *)aTitle cancelButtonTitle:(NSString *)aCancelTitle destructiveButtonTitle:(NSString *)aDestructiveTitle otherButtonTitles:(NSString *)otherTitles,... {
    self = [super init];
    if (self) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:aTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        if (otherTitles != nil) {
            [actionSheet addButtonWithTitle:otherTitles];
            va_list args;
            va_start(args, otherTitles);
            NSString * title = nil;
            while((title = va_arg(args,NSString*))) {
                [actionSheet addButtonWithTitle:title];
            }
            va_end(args);
        }
        
        if (aDestructiveTitle) {
            [actionSheet addButtonWithTitle:aDestructiveTitle];
            actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons-1;
        }
        
        if (aCancelTitle) {
            [actionSheet addButtonWithTitle:aCancelTitle];
            actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-1;
        }
        
        self.activeActionSheet = actionSheet;
    }
    return self;
}

#pragma mark - Public (Functionality)

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated dismissHandler:(ActionSheetDismissedHandler)handler
{
    self.activeDismissHandler = handler;
    self.strongActionSheetReference = self;
    [self.activeActionSheet showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated dismissHandler:(ActionSheetDismissedHandler)handler
{
    self.activeDismissHandler = handler;
    self.strongActionSheetReference = self;
    [self.activeActionSheet showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view dismissHandler:(ActionSheetDismissedHandler)handler
{
    self.activeDismissHandler = handler;
    self.strongActionSheetReference = self;
    [self.activeActionSheet showInView:view];
}

#pragma mark - Properties

- (void) setActionSheetStyle:(UIActionSheetStyle)actionSheetStyle
{
    self.activeActionSheet.actionSheetStyle = actionSheetStyle;
}

- (UIActionSheetStyle)actionSheetStyle{
    return self.activeActionSheet.actionSheetStyle;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.activeDismissHandler) {
        self.activeDismissHandler(buttonIndex, buttonIndex == actionSheet.cancelButtonIndex, buttonIndex == actionSheet.destructiveButtonIndex);
    }
    self.strongActionSheetReference = nil;
}

@end
