//
//  BXULocationViewController.h
//  Bit6UI
//
//  Created by Carlos Thurber on 01/14/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol BXULocationViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/*! Convenience subclass of UIViewController to display a location in a MKMapView. 
 @discussion This viewController will present an UITabBar with options to open the location in AppleMaps, others applications can be configured as well using the <BXULocationViewControllerDelegate> protocol. 
 */
@interface BXULocationViewController : UIViewController

/*! Location to display in the sender. */
@property (nonatomic) CLLocationCoordinate2D coordinate;

/*! Additional actions to display in the sender's UITabBar. These can be handled using the <BXULocationViewControllerDelegate> protocol. */
@property (nullable, strong, nonatomic) NSArray<NSString*>* actions;

/*! The delegate to be notified when an action has been selected in the viewcontroller or it has to be dismissed. For details about the methods that can be implemented by the delegate, see <BXULocationViewControllerDelegate> Protocol Reference. */
@property (nullable, weak, nonatomic) id<BXULocationViewControllerDelegate> delegate;

@end

/*! The BXULocationViewControllerDelegate protocol defines the methods a delegate of a <BXULocationViewController> object should implement. The methods of this protocol notify the delegate when an action has been selected in the viewcontroller or it has to be dismissed. */
@protocol BXULocationViewControllerDelegate <NSObject>

/*! Called when the user decide to dismiss the viewcontroller. It is necessary to implement this method to dismiss this viewcontroller.
 @param locationViewController view controller to dismiss
 */
- (void)dismissLocationViewController:(BXULocationViewController*)locationViewController;

@optional

/*! Called when the user selects one of the <BXULocationViewController.actions> defined.
 @param action action selected
 @param coordinate location's coordinate
 */
- (void)didSelectLocationAction:(NSString*)action coordinate:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END