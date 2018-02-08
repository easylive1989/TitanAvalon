//
//  Relationship.swift
//  TitanAvalon
//
//  Created by paulps on 2018/1/26.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

class Relationship {
    
    var myself : User
    var users : [User]
    
    init(_ myself : User, _ users : [User]) {
        self.myself = myself
        self.users = users
    }
    
    fileprivate func getEvils(_ exclude: Character) -> [User] {
        var evils : [User] = []
        for user in users {
            let character = user.character!
            if character.isEvils() && character != exclude && character != myself.character {
                evils.append(user)
            }
        }
        
        return evils
    }
    
    fileprivate func getMerlinAdnMorcana() -> [User] {
        var result : [User] = []
        for user in users {
            let character = user.character!
            if character == .Merlin || character == .Morcana {
                result.append(user)
            }
        }
        return result
    }
    
    func canSee() -> [User] {
        switch myself.character {
        case .Merlin?:
            return getEvils(.Mordred)
        case .Percival?:
            return getMerlinAdnMorcana()
        case .Assassin?, .Morcana?, .Mordred?, .MsOfMordred?:
            return getEvils(.Oberon)
        case .Oberon?, .LsOfArther1?, .LsOfArther2?, .LsOfArther3?, .LsOfArther4?, .none:
            return []
        }
    }
}
