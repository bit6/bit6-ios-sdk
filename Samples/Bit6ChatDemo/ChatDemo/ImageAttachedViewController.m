//
//  ImageAttachedViewController.m
//  Bit6ChatDemo
//
//  Created by Carlos Thurber Boaventura on 06/05/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "ImageAttachedViewController.h"

@interface ImageAttachedViewController ()

@property (weak, nonatomic) IBOutlet Bit6ImageView *imageView;

@end

@implementation ImageAttachedViewController

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void) viewDidLoad
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",Bit6.session.userIdentity.displayName];
    self.hidesBottomBarWhenPushed = YES;
    
    self.imageView.message = self.message;
    [super viewDidLoad];
}

@end
