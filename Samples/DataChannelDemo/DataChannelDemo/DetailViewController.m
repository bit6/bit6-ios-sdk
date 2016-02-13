//
//  DetailViewController.m
//  DataChannelDemo
//
//  Created by Carlos Thurber on 04/06/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void) addImage:(UIImage*)image
{
    self.imageView.image = image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
