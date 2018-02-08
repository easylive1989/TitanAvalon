//
//  Game.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/3.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func onEventHappend(_ event: Event)
}

class Game : SetupRoundDelegate {
    
    func onSetupEventHappend(_ event: SetupRoundEvent) {
        
    }
    
    
    
    fileprivate let users : [User]
    
    var setupRound: SetupRound
    
    init(_ users: [User]) {
        self.users = users
        setupRound = SetupRound(self.users)
    }
    
    func start() {
        do {
            try setupRound.nextStage()
        } catch {
            terminate()
        }
    }
    
    func terminate() {
    }
}
