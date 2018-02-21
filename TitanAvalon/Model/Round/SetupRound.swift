//
//  SetupRound.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/3.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

enum SetupStatus : Int {
    case NotStart = 0
    case AllCloseEye = 1
    case EvilsCheck = 2
    case EvilsCheckEnd = 3
    case AllCloseEye2 = 4
    case EvilsShow = 5
    case MerlinCheck = 6
    case EvilsHide = 7
    case MerlinCheckEnd = 8
    case MerlinAndMorcanaShow = 9
    case PercivalCheck = 10
    case MerlinAndMorcanaHide = 11
    case PercivalCheckEnd = 12
    case SetupDone = 13
    
    func canChangeTo(_ newStatus: SetupStatus) -> Bool {
        return newStatus.rawValue - self.rawValue == 1
    }
}

protocol SetupRoundDelegate {
    func onSetupEventHappend(_ event: SetupRoundEvent)
}

class SetupRound : SetupRoundRepositoryDelegate {
    
    fileprivate var users : [User]
    var delegate : SetupRoundDelegate?
    fileprivate var status : SetupStatus = .NotStart
    fileprivate var repo : ISetupRoundRepository
    
    init(_ users: [User], repo: ISetupRoundRepository) {
        self.users = users
        self.repo = repo
        self.repo.delegate = self
    }
    
    func setStatus(_ status : SetupStatus) {
        self.status = status
        
        let events : [SetupRoundEvent] = createEvent(status)
        
        triggerEvent(events)
    }
    
    func nextStatus() {
        if status == .SetupDone {
            return
        }
        
        let nextStatus = SetupStatus(rawValue: self.status.rawValue + 1)!
        
        repo.setStatus(status: nextStatus)
    }
    
    func onNewStatus(status: SetupStatus) {
        setStatus(status)
    }
    
    fileprivate func createEvent(_ status: SetupStatus) -> [SetupRoundEvent] {
        let publicEvents =  createPublicEvent(status)
        let privateEvents = createPrivateEvent(status)
        return publicEvents + privateEvents
    }
    
    fileprivate func createPublicEvent(_ status: SetupStatus) -> [SetupRoundEvent] {
        return [SetupRoundEvent(status)]
    }
    
    fileprivate func createPrivateEvent(_ status: SetupStatus) -> [SetupRoundEvent] {
        if status == .EvilsCheck {
            return createEvilsCheckEvent()
        } else if status == .MerlinCheck {
            return createMerlinCheckEvent()
        } else if status == .PercivalCheck{
            return createPercivalCheckEvent()
        } else {
            return []
        }
    }
    
    fileprivate func createEvilsCheckEvent() -> [SetupRoundEvent] {
        return createCheckEvent(.EvilsCheck, .Morcana, .Assassin, .Mordred, .MsOfMordred)
    }
    
    fileprivate func createMerlinCheckEvent() -> [SetupRoundEvent] {
        return createCheckEvent(.MerlinCheck, .Merlin)
    }
    
    fileprivate func createPercivalCheckEvent() -> [SetupRoundEvent] {
        return createCheckEvent(.PercivalCheck, .Percival)
    }
    
    fileprivate func createCheckEvent(_ status: SetupStatus, _ characters: Character...) -> [SetupRoundEvent] {
        let actors = users.filter{characters.contains($0.character!)}
        
        var events : [SetupRoundEvent] = []
        for actor in actors {
            events.append(SetupRoundEvent(status, actor, actor.relationship!.canSee()))
        }
        
        return events
    }
    
    fileprivate func triggerEvent(_ event: SetupRoundEvent) {
        if delegate != nil {
            delegate?.onSetupEventHappend(event)
        }
    }
    
    fileprivate func triggerEvent(_ events: [SetupRoundEvent]) {
        for event in events {
            triggerEvent(event)
        }
    }
}
