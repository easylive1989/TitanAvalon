//
//  KingArther.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/8.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

class KingArther {
    
    fileprivate var users : [User]
    fileprivate var kingArther : User
    
    init(_ users : [User]) {
        self.users = users
        self.kingArther = users[Int(arc4random_uniform(UInt32(users.count)))]
    }
    
    func setKingArther(_ user : User) {
        kingArther = user
    }
    
    func getKingArther() -> User {
        return kingArther
    }
    
    func nextKingArther() {
        let kingArtherIdx = users.index(of: kingArther)
        let nextKingArtherIdx = (kingArtherIdx!+1) % users.count
        kingArther = users[nextKingArtherIdx]
    }
    
}
