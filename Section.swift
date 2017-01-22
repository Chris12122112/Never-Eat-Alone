//
//  Section.swift
//  NEA4
//
//  Created by Chris Wang on 1/21/17.
//  Copyright © 2017 Chris Wang. All rights reserved.
//

import Foundation

struct Section {
    var heading : String
    var items: [String]
    
    init(title: String, objects : [String]) {
        heading = title
        items = objects
    }
}
