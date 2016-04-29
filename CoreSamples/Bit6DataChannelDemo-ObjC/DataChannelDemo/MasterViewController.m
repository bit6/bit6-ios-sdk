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

@interface MasterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITextView *logsTextView;
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
                                                 selector:@selector(transferUpdateNotification:)
                                                     name:Bit6TransferUpdateNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logsTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.logsTextView.layer.borderWidth = 1.0f;
    
    if (![Bit6 session].authenticated) {
        [self login];
    }
    else {
        [self loginCompletionHandler](nil,nil);
    }
}

- (void) log:(NSString*)log
{
    NSString *string = [NSString stringWithString:self.logsTextView.text];
    string = [NSString stringWithFormat:@"%@\n%@",log,string];
    self.logsTextView.text = string;
}

#pragma mark - Login

- (void)login
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login" message:@"Enter your username and password" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Username";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Sign Up" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                UITextField *userTextField = alert.textFields[0];
                                                NSString *user = userTextField.text;
                                                UITextField *passTextField = alert.textFields[1];
                                                NSString *pass = passTextField.text;
                                                
                                                Bit6Address *userIdentity = [Bit6Address addressWithUsername:user];
                                                [Bit6.session signUpWithUserIdentity:userIdentity password:pass completionHandler:[self loginCompletionHandler]];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                UITextField *userTextField = alert.textFields[0];
                                                NSString *user = userTextField.text;
                                                UITextField *passTextField = alert.textFields[1];
                                                NSString *pass = passTextField.text;
                                                
                                                Bit6Address *userIdentity = [Bit6Address addressWithUsername:user];
                                                [Bit6.session loginWithUserIdentity:userIdentity password:pass completionHandler:[self loginCompletionHandler]];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Anonymous" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                [Bit6.session anonymousWithCompletionHandler:[self loginCompletionHandler]];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)logout
{
    [[Bit6 session] logoutWithCompletionHandler:^(NSDictionary<id,id> * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.addressLabel.text = @"My Address:";
                self.navigationItem.leftBarButtonItem = nil;
                [self login];
            });
        }
    }];
}

- (Bit6CompletionHandler)loginCompletionHandler
{
    return ^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self login];
            }
            else {
                self.addressLabel.text = [NSString stringWithFormat:@"My Address: %@",Bit6.session.activeIdentity.uri];
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];;
            }
        });
    };
}

#pragma mark - Call

- (void)setCallController:(Bit6CallController *)callController
{
    if (_callController) {
        [_callController removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
    }
    _callController = callController;
    if (callController) {
        [callController addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (IBAction)connect:(id)sender {
    if (! [[Bit6 callControllers] firstObject]) {
        NSString *destinationString = self.destinationTextField.text;
        Bit6Address *address = nil;
        if ([destinationString rangeOfString:@":"].location != NSNotFound) {
            address = [Bit6Address addressWithURI:destinationString];
        }
        else {
            Bit6Address *currentUser = Bit6.session.activeIdentity;
            NSString *scheme = currentUser.scheme;
            address = [Bit6Address addressWithScheme:scheme value:destinationString];
        }
        
        if (address) {
            [Bit6 startCallTo:address streams:Bit6CallStreams_Data];
        }
    }
    else {
        [self.callController hangup];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (object == self.callController) {
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
                [self callStateChangedNotification];
            }
        }
    });
}

- (void)callStateChangedNotification
{
    switch (self.callController.state) {
        case Bit6CallState_MISSED:
            self.callController = nil;
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Missed Call from %@",self.callController.otherDisplayName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        case Bit6CallState_NEW: case Bit6CallState_ACCEPTING_CALL: case Bit6CallState_GATHERING_CANDIDATES: case Bit6CallState_WAITING_SDP: case Bit6CallState_SENDING_SDP: case Bit6CallState_CONNECTING: case Bit6CallState_DISCONNECTED: break;
        case Bit6CallState_CONNECTED:
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(selectPicture:)];
            [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
            self.destinationTextField.enabled = NO;
            break;
        case Bit6CallState_END: case Bit6CallState_ERROR:
            self.navigationItem.rightBarButtonItem = nil;
            [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
            self.callController = nil;
            self.destinationTextField.enabled = YES;
    }
}

#pragma mark - Send Picture

- (void)selectPicture:(UIBarButtonItem*)buttonItem
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
        
        Bit6OutgoingTransfer *transfer = [[Bit6OutgoingTransfer alloc] initWithData:imageData name:nil mimeType:@"image/png"];
        
        [self log:[NSString stringWithFormat:@"%@ - selected - type: %@ size: %lub\n", transfer.name, transfer.mimeType, (unsigned long)transfer.size]];
        [self.callController startTransfer:transfer];
    }
    [self dismissPopover];
}

- (void)disconnect
{
    [self.callController hangup];
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.myPopoverController = nil;
}

- (void)dismissPopover
{
    [self.myPopoverController dismissPopoverAnimated:YES];
    self.myPopoverController = nil;
}

#pragma mark - Transfers

- (void)transferUpdateNotification:(NSNotification*)notification
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
