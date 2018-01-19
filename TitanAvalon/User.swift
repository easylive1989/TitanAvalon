//
//  User.swift
//  TitanAvalon
//
//  Created by paulps on 2018/1/19.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

class User : Hashable {
    var hashValue: Int
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name : String
    
    init(_ name:String) {
        self.name = name
        self.hashValue = name.hashValue
    }
}
