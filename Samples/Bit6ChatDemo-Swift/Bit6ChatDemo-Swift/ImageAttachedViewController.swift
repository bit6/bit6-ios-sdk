//
//  ImageAttachedViewController.swift
//  Bit6ChatDemo-Swift
//
//  Created by Carlos Thurber on 11/23/14.
//  Copyright (c) 2014 Bit6. All rights reserved.
//

import UIKit

class ImageAttachedViewController: UIViewController {

    var message : Bit6Message!

    @IBOutlet var imageView: Bit6ImageView!
    
    override func viewDidLoad() {
        self.navigationItem.prompt = "Logged as \(Bit6.session().userIdentity.displayName)"
        self.imageView.message = self.message
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
}
