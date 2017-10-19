//
//  User.swift
//  Dont Be Fat
//
//  Created by Roman on 7/2/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import UIKit

class User: NSObject {
    var name:String?
    var facebookID:String?
    var email:String?
    var highestScore:Int = 0
    var friends:NSDictionary?
    var profilePictureURL:String?
}
