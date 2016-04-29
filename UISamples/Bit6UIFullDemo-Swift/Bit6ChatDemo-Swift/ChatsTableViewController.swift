//
//  ChatsTableViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber Boaventura on 07/08/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit
import MobileCoreServices
import Bit6
import Bit6UI

class ChatsTableViewController: BXUMessageTableViewController, BXULocationViewControllerDelegate, BXUImageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let button = UIButton(type: .InfoLight)
        button.addTarget(self, action:#selector(ChatsTableViewController.showDetailInfo), forControlEvents:.TouchUpInside)
        let detailButton = UIBarButtonItem(customView: button)

        self.navigationItem.rightBarButtonItems = [detailButton, self.callButtonItem]
    }
    
    // MARK: - BXUMessageTableViewDelegate
    
    override func didSelectImageMessage(message: Bit6Message) {
        let imageVC = BXUImageViewController()
        imageVC.delegate = self
        imageVC.setMessage(message)
        
        let navController = UINavigationController(rootViewController:imageVC)
        navController.navigationBar.barStyle = (self.navigationController?.navigationBar.barStyle)!

        if let barTintColor = self.navigationController?.navigationBar.barTintColor {
            navController.navigationBar.barTintColor = barTintColor
        }
        if let titleTextAttributes = self.navigationController?.navigationBar.titleTextAttributes {
            navController.navigationBar.titleTextAttributes = titleTextAttributes
        }
        if let tintColor = self.navigationController?.navigationBar.tintColor {
            navController.navigationBar.tintColor = tintColor
        }
        
        navController.navigationBar.translucent = false
        navController.toolbar.translucent = false
        navController.modalPresentationStyle = .FormSheet
        presentViewController(navController, animated:true, completion:nil)
        
    }
    
    override func didSelectVideoMessage(message: Bit6Message) {
        Bit6.playVideoFromMessage(message, viewController:self.navigationController!)
    }
    
    override func didSelectLocationMessage(message: Bit6Message) {
        let locationVC = BXULocationViewController()
        locationVC.delegate = self
        locationVC.coordinate = message.location;
        
        var actions = [String]()
        if UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps-x-callback://")!) {
            actions.append("Google Maps")
        }
        if UIApplication.sharedApplication().canOpenURL(NSURL(string:"waze://")!) {
            actions.append("Waze")
        }
        locationVC.actions = actions;
        
        let navController = UINavigationController(rootViewController:locationVC)
        navController.navigationBar.barStyle = (self.navigationController?.navigationBar.barStyle)!
        
        if let barTintColor = self.navigationController?.navigationBar.barTintColor {
            navController.navigationBar.barTintColor = barTintColor
        }
        if let titleTextAttributes = self.navigationController?.navigationBar.titleTextAttributes {
            navController.navigationBar.titleTextAttributes = titleTextAttributes
        }
        if let tintColor = self.navigationController?.navigationBar.tintColor {
            navController.navigationBar.tintColor = tintColor
        }
        
        navController.navigationBar.translucent = false
        navController.toolbar.translucent = false
        navController.modalPresentationStyle = .FormSheet
        presentViewController(navController, animated:true, completion:nil)
    }
    
    // MARK: - BXULocationViewControllerDelegate
    
    func dismissLocationViewController(locationViewController: BXULocationViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didSelectLocationAction(action: String, coordinate: CLLocationCoordinate2D) {
        if action == "Google Maps" {
            let urlStr = "comgooglemaps-x-callback://?q=\(coordinate.latitude),\(coordinate.longitude)&zoom=14&x-success=bit6fulldemo://&x-source=Bit6Demo"
            UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
        }
        else if action == "Waze" {
            let urlStr = "waze://?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes"
            UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
        }
    }
    
    // MARK: -BXUImageViewControllerDelegate
    
    func dismissImageViewController(imageViewController: BXUImageViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    
    func showDetailInfo() {
        self.performSegueWithIdentifier("showDetails", sender:nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetails" {
            let obj = segue.destinationViewController as! ConversationDetailsTableViewController
            obj.conversation = Bit6Conversation(address:self.address)
        }
    }
}
