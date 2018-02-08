//
//  SetupRoundEvent.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/6.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

class SetupRoundEvent : Event {
    
    var status : SetupStatus
    var eventActor : User?
    var passive : [User]
    
    convenience init(_ status: SetupStatus) {
        self.init(status, nil, [])
    }
    
    init(_ status: SetupStatus, _ actor: User?, _ passive: [User]) {
        self.eventActor = actor
        self.passive = passive
        self.status = status
    }
}
