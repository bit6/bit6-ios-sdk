//
//  AttachmentsTableViewController.m
//  BasicDemo
//
//  Created by Carlos Thurber Boaventura on 05/02/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

#import "AttachmentsTableViewController.h"

@interface AttachmentsTableViewController () <Bit6ThumbnailImageViewDelegate>

@end

@implementation AttachmentsTableViewController

- (void) viewDidLoad
{
    self.navigationItem.prompt = [NSString stringWithFormat:@"Logged as %@",[Bit6Session userIdentity].displayName];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL) hidesBottomBarWhenPushed {
    return YES;
}

#pragma mark - TableView

static int imagesForCell = 4;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attachmentMessagesArray.count/imagesForCell + (self.attachmentMessagesArray.count%imagesForCell!=0?1:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *attachmentCellIdentifier = @"attachmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attachmentCellIdentifier];
    Bit6ThumbnailImageView *imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:1];
    imageView.thumbnailImageViewDelegate = self;
    imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:2];
    imageView.thumbnailImageViewDelegate = self;
    imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    imageView.thumbnailImageViewDelegate = self;
    imageView = (Bit6ThumbnailImageView*) [cell viewWithTag:4];
    imageView.thumbnailImageViewDelegate = self;
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bit6ThumbnailImageView *imageView1 = (Bit6ThumbnailImageView*) [cell viewWithTag:1];
    Bit6ThumbnailImageView *imageView2 = (Bit6ThumbnailImageView*) [cell viewWithTag:2];
    Bit6ThumbnailImageView *imageView3 = (Bit6ThumbnailImageView*) [cell viewWithTag:3];
    Bit6ThumbnailImageView *imageView4 = (Bit6ThumbnailImageView*) [cell viewWithTag:4];
    
    long index = indexPath.row*imagesForCell;
    imageView1.message = index<self.attachmentMessagesArray.count?self.attachmentMessagesArray[index]:nil;
    imageView2.message = (index+1)<self.attachmentMessagesArray.count?self.attachmentMessagesArray[(index+1)]:nil;
    imageView3.message = (index+2)<self.attachmentMessagesArray.count?self.attachmentMessagesArray[(index+2)]:nil;
    imageView4.message = (index+3)<self.attachmentMessagesArray.count?self.attachmentMessagesArray[(index+3)]:nil;
    
}

#pragma mark - Bit6ThumbnailImageViewDelegate

- (void) touchedThumbnailImageView:(Bit6ThumbnailImageView*)thumbnailImageView
{
    Bit6Message *msg = thumbnailImageView.message;
    if (msg.type == Bit6MessageType_Location) {
        [msg openLocationOnMaps];
    }
    else if (msg.type == Bit6MessageType_Attachments) {
        if (msg.attachFileType == Bit6MessageFileType_AudioMP4) {
            [[Bit6AudioPlayerController sharedInstance] startPlayingAudioFileInMessage:msg];
        }
        else if (msg.attachFileType == Bit6MessageFileType_VideoMP4) {
            [msg playVideoOnViewController:self.navigationController];
        }
    }
}

@end
