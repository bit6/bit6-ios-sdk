//
//  DetailViewController.m
//  DataChannelDemo
//
//  Created by Carlos Thurber on 04/06/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) NSMutableArray *images;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

#warning show more received images

- (NSMutableArray*) images
{
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:10];
    }
    return _images;
}

- (void) addImage:(UIImage*)image
{
    [self.images addObject:image];
    self.imageView.image = image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
