//
//  MasterViewController.m
//  DataChannelDemo
//
//  Created by Carlos Thurber on 04/06/15.
//  Copyright (c) 2015 Bit6. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import <Bit6SDK/Bit6SDK.h>

@interface MasterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITextView *logsTextView;
@property (strong, nonatomic) Bit6CallController *callController;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *sentLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;

@property (strong, nonatomic) UIPopoverController *myPopoverController;

@end

@implementation MasterViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginCompletedNotification:)
                                                     name:Bit6LoginCompletedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(transferUpdateNotification:)
                                                     name:Bit6TransferUpdateNotification
                                                   object:nil];
    }
    return self;
}

- (void) loginCompletedNotification:(NSNotification*)notification
{
    self.addressLabel.text = [NSString stringWithFormat:@"My Address: %@",Bit6.session.userIdentity.uri];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logsTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.logsTextView.layer.borderWidth = 1.0f;
    self.addressLabel.text = [NSString stringWithFormat:@"My Address: %@",Bit6.session.userIdentity.uri];
}

- (void) log:(NSString*)log
{
    NSString *string = [NSString stringWithString:self.logsTextView.text];
    string = [NSString stringWithFormat:@"%@\n%@",log,string];
    self.logsTextView.text = string;
}

#pragma mark - Call

- (IBAction)connect:(id)sender {
    if (! self.callController) {
        NSString *destinationString = self.destinationTextField.text;
        Bit6Address *address = nil;
        if ([destinationString rangeOfString:@":"].location != NSNotFound) {
            address = [Bit6Address addressWithURI:destinationString];
        }
        else {
            Bit6Address *currentUser = Bit6.session.userIdentity;
            Bit6AddressKind kind = [currentUser.kind intValue];
            address = [Bit6Address addressWithKind:kind value:destinationString];
        }
        
        if (address) {
            self.callController = [Bit6 startCallToAddress:address hasAudio:NO hasVideo:NO hasData:YES];
            [self.callController addObserver:self forKeyPath:@"callState" options:NSKeyValueObservingOptionNew context:NULL];
            [self.callController connectToViewController:nil];
        }
    }
    else {
        [self.callController removeObserver:self forKeyPath:@"callState"];
        [self.callController hangup];
        self.callController = nil;
        [self connect:nil];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (object == self.callController) {
            if ([keyPath isEqualToString:@"callState"]) {
                [self callStateChangedNotification];
            }
        }
    });
}

- (void) callStateChangedNotification
{
    switch (self.callController.callState) {
        case Bit6CallState_NEW: case Bit6CallState_PROGRESS: case Bit6CallState_MISSED: case Bit6CallState_DISCONNECTED: break;
        case Bit6CallState_ANSWER:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(selectPicture:)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
            self.destinationTextField.enabled = NO;
            self.connectButton.enabled = NO;
            break;
        case Bit6CallState_END: case Bit6CallState_ERROR:
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            [self.callController removeObserver:self forKeyPath:@"callState"];
            self.callController = nil;
            self.destinationTextField.enabled = YES;
            self.connectButton.enabled = YES;
    }
}

#pragma mark - Send Picture

- (void) selectPicture:(UIBarButtonItem*)buttonItem
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
    self.myPopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    self.myPopoverController.delegate = self;
    
    [self.myPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]) {
        
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        
        Bit6Transfer *transfer = [[Bit6Transfer alloc] initOutgoingTransferWithData:imageData name:nil mimeType:@"image/png"];
        [self log:[NSString stringWithFormat:@"%@ - selected - type: %@ size: %lub\n", transfer.name, transfer.mimeType, (unsigned long)transfer.size]];
        [self.callController startTransfer:transfer];
    }
    [self dismissPopover];
}

- (void) logout
{
    [self.callController hangup];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.myPopoverController = nil;
}

- (void) dismissPopover
{
    [self.myPopoverController dismissPopoverAnimated:YES];
    self.myPopoverController = nil;
}

#pragma mark - Transfers

- (void) transferUpdateNotification:(NSNotification*)notification
{
    Bit6Transfer *object = notification.userInfo[Bit6ObjectKey];
    NSString *change = notification.userInfo[Bit6ChangeKey];
    Bit6CallController *callController = notification.object;
    
    if (callController == self.callController) {
        if ([change isEqualToString:Bit6TransferStartedKey]) {
            [self log:[NSString stringWithFormat:@"%@ - STARTED\n", object.name]];
        }
        else if ([change isEqualToString:Bit6TransferProgressKey]) {
            CGFloat progressAtTheMoment = [notification.userInfo[Bit6ProgressKey] floatValue]*100.0;
            if (object.type == Bit6TransferType_INCOMING) {
                self.receiveLabel.text = [NSString stringWithFormat:@"Recv: %@ %.2f%%", object.name, progressAtTheMoment];
            }
            else {
                self.sentLabel.text = [NSString stringWithFormat:@"Send: %@ %.2f%%", object.name, progressAtTheMoment];
            }
            
        }
        else if ([change isEqualToString:Bit6TransferEndedKey]) {
            if (object.type == Bit6TransferType_INCOMING) {
                [self log:[NSString stringWithFormat:@"%@ - RECEIVED", object.name]];
                
                NSData *data = object.data;
                
                if ([object.mimeType hasPrefix:@"image/"]) {
                    DetailViewController *detail = (DetailViewController *)[self.splitViewController.viewControllers[1] topViewController];
                    [detail addImage:[UIImage imageWithData:data]];
                }
            }
            else {
                [self log:[NSString stringWithFormat:@"%@ - SENT", object.name]];
            }
        }
        else if ([change isEqualToString:Bit6TransferEndedWithErrorKey]) {
            NSLog(@"%@",object.error.localizedDescription);
        }
    }
}

@end
