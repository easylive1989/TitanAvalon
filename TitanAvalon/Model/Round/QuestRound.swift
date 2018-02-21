//
//  QuestRound.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/8.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

enum Execute : Int {
    case Success = 0
    case Fail = 1
}

enum Vote : Int {
    case Approve = 0
    case Reject = 1
}

enum QuestStatus : Int {
    case QuestStart = 0
    case Assigning = 1
    case Assigned = 2
    case Voting = 3
    case Voted = 4
    case Executing = 5
    case Executed = 6
    case QuestEnd = 7
}

protocol QuestRoundDelegate {
    func onQuestEventHappend(_ event : QuestRoundEvent)
}

class QuestRound : QuestRoundRepositoryDelegate {
    
    var users : [User]
    
    let kingArther : KingArther
    var status : QuestStatus
    var delegate : QuestRoundDelegate?
    fileprivate var repo : IQuestRoundRepository
    
    fileprivate var executors : [User] = []
    fileprivate var assignFailCount : Int = 0
    fileprivate var votes : [Vote] = []
    fileprivate var executes : [Execute] = []
    
    init(_ kingArther : KingArther, _ users : [User], _ repo : IQuestRoundRepository) {
        self.kingArther = kingArther
        self.users = users
        self.status = .QuestStart
        self.repo = repo
        self.repo.delegate = self
    }
    
    func nextStatus() {
        let nextStatus = QuestStatus(rawValue: status.rawValue + 1)!
        
        repo.setStatus(status: nextStatus)
    }
    
    func setStatus(_ status : QuestStatus) {
        self.status = status
        
        let events = createEvent(status)
        
        triggerEvent(events)
    }
    
    func onNewStatus(status: QuestStatus) {
        setStatus(status)
    }
    
    func onExecutorAssigned(userNames: [String]) {
        self.executors = users.filter{userNames.contains($0.name)}
        if status == .Assigning {
            nextStatus()
        }
    }
    
    func onVoted(votes: [Vote]) {
        self.votes = votes
        
        if status == .Voting && isAllVoted() {
            nextStatus()
        }
    }
    
    func onExecuted(executes: [Execute]) {
        self.executes = executes
        
        if status == .Executing && isAllExecuted() {
            nextStatus()
        }
    }
    
    fileprivate func createEvent(_ status : QuestStatus) -> QuestRoundEvent {
        if status == .Assigned {
            return createAssignedEvent()
        } else if status == .Voted {
            return createVotedEvent()
        } else if status == .Executed {
            return createExecutedEvent()
        } else {
            return QuestRoundEvent(status, kingArther.getKingArther())
        }
    }
    
    fileprivate func createAssignedEvent() -> QuestRoundEvent {
        return QuestRoundEvent(.Assigned, kingArther.getKingArther(), executors)
    }
    
    fileprivate func createVotedEvent() -> QuestRoundEvent {
        let isVoteApproved = generateVoteResult()
        if !isVoteApproved {
            assignFailCount += 1
        }
        return QuestRoundEvent(.Voted, kingArther.getKingArther(), isVoteApproved)
    }
    
    func resetQuest() {
        kingArther.nextKingArther()
        repo.setStatus(status: .QuestStart)
        repo.clearData()
    }
    
    fileprivate func createExecutedEvent() -> QuestRoundEvent {
        let isExecuteSuccess = generateExecuteResult()
        return QuestRoundEvent(.Executed, kingArther.getKingArther(), isExecuteSuccess)
    }
    
    fileprivate func createGeneralEvent(_ status : QuestStatus) -> QuestRoundEvent {
        return QuestRoundEvent(status, kingArther.getKingArther())
    }
    
    fileprivate func generateVoteResult() -> Bool {
        return votes.filter{$0 == .Approve}.count > votes.filter{$0 == .Reject}.count
    }
    
    fileprivate func generateExecuteResult() -> Bool {
        return executes.filter{$0 == .Success}.count > executes.filter{$0 == .Fail}.count
    }
    
    func assign(_ users : [User]) {
        //executors.append(contentsOf: users)
        repo.assignExecutor(users: users)
    }
    
    func vote(_ vote: Vote) {
        //trigger next result
        //self.votes.append(vote)
        
        repo.vote(vote: vote)
        
    }
    
    fileprivate func isAllVoted() -> Bool {
        return votes.count == users.count
    }
    
    func execute(_ execute : Execute) {
        repo.execute(execute: execute)
    }
    
    fileprivate func isAllExecuted() -> Bool {
        return executes.count == executors.count
    }
    
    fileprivate func triggerEvent(_ event: QuestRoundEvent) {
        if delegate != nil {
            delegate?.onQuestEventHappend(event)
        }
    }
}
