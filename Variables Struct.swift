//
//  Variables Struct.swift
//  NEA4
//
//  Created by Chris Wang on 1/22/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import Foundation
import Firebase

struct Constants {
    static var eatingEstablishmentThatWasSelected = "placeholder"
    static var currentUserID = FIRAuth.auth()?.currentUser?.uid
    static var currentUserName = "default"
}
