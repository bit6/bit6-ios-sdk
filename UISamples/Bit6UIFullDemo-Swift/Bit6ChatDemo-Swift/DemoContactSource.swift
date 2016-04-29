//
//  DemoContactSource.swift
//  Bit6UIFullDemo
//
//  Created by Carlos Thurber on 04/20/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

import Foundation
import Bit6UI

class DemoContactSource : NSObject, BXUContactSource {
 
    func contactForURI(uri: String) -> BXUContact? {
        return source[uri]
    }
    
    //WARNING:  here you can set the displaynames and avatars for each user
    lazy var source = ["usr:alex" : DemoContact(uri:"usr:alex", name:"Alexey Goloshubin", avatarURL:nil),
                       "usr:julia": DemoContact(uri:"usr:julia", name:"Julia Goloshubin", avatarURL:nil),
                       "usr:calitb": DemoContact(uri:"usr:calitb", name:"Carlos Thurber", avatarURL:nil)]
    
}

class DemoContact : NSObject, BXUContact {
    
    var _uri: String
    var _name: String
    var _avatarURL : NSURL?
    
    init(uri:String, name:String, avatarURL:NSURL?) {
        _uri = uri
        _name = name
        _avatarURL = avatarURL
    }
    
    func uri() -> String {
        return _uri
    }
    
    func name() -> String {
        return _name
    }
    
    func avatarURL() -> NSURL? {
        return _avatarURL
    }
    
}