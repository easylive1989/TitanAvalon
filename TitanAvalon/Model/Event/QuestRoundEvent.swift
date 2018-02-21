//
//  QuestRoundEvent.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/9.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

class QuestRoundEvent : Event {
    
    var status : QuestStatus
    var eventActor : User?
    var passive : [User]
    var isEventSuccess : Bool = true
    var kingArther : User
    
    convenience init(_ status: QuestStatus, _ kingArther : User) {
        self.init(status, kingArther, [] , true)
    }
    
    convenience init(_ status: QuestStatus, _ kingArther : User, _ passive: [User]) {
        self.init(status, kingArther, passive , true)
    }
    
    convenience init(_ status: QuestStatus, _ kingArther : User, _ isEventSuccess : Bool) {
        self.init(status, kingArther, [] , isEventSuccess)
    }
    
    init(_ status: QuestStatus, _ kingArther : User, _ passive: [User], _ isEventSuccess : Bool) {
        self.eventActor = nil
        self.kingArther = kingArther
        self.passive = passive
        self.status = status
        self.isEventSuccess = isEventSuccess
    }
    
    func isAutoChangeStatus() -> Bool {
        return status != .Assigning && status != .Voting && status != .Executing
    }
}
