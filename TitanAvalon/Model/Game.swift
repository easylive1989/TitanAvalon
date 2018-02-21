//
//  Game.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/21.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func onQuestEventHappend(_ event: QuestRoundEvent)
    func onSetupEventHappend(_ event: SetupRoundEvent)
}

class Game : SetupRoundDelegate, QuestRoundDelegate {
    
    var delegate : GameDelegate?
    
    fileprivate var users : [User]
    
    fileprivate var kingArther : KingArther?
    fileprivate var setupRound : SetupRound?
    fileprivate var curQuestRoundIdx : Int = 0
    fileprivate var questRounds : [QuestRound]?
    
    init(_ users: [User], _ pincode: String) {
        self.users = users
        kingArther = KingArther(users)
        setupRound = SetupRound(users, repo: SetupRoundRepository(pincode: pincode))
        setupRound?.delegate = self
        questRounds = [ QuestRound(kingArther!, users, QuestRoundRepository(1, pincode)),
                        QuestRound(kingArther!, users, QuestRoundRepository(2, pincode)),
                        QuestRound(kingArther!, users, QuestRoundRepository(3, pincode)),
                        QuestRound(kingArther!, users, QuestRoundRepository(4, pincode)),
                        QuestRound(kingArther!, users, QuestRoundRepository(5, pincode))]
    }
    
    func start() {
        setupRound!.nextStatus()
    }
    
    func sendCommand(_ command: String) {
        if command.hasPrefix("/assign") {
            var cmdAndParams = command.split(separator: " ")
            let executorNames = cmdAndParams[1...cmdAndParams.count-1]
            let executors = users.filter{String(describing: executorNames).contains($0.name)}
            self.questRounds![self.curQuestRoundIdx].assign(executors)
        } else if command.hasPrefix("/vote") {
            var cmdAndParams = command.split(separator: " ")
            let voted = cmdAndParams[1]
            if String(voted) == "Approve" {
                self.questRounds![self.curQuestRoundIdx].vote(.Approve)
            } else {
                self.questRounds![self.curQuestRoundIdx].vote(.Reject)
            }
        } else if command.hasPrefix("/execute") {
            var cmdAndParams = command.split(separator: " ")
            let executed = cmdAndParams[1]
            if String(executed) == "Success" {
                self.questRounds![self.curQuestRoundIdx].execute(.Success)
            } else {
                self.questRounds![self.curQuestRoundIdx].execute(.Fail)
            }
        }
    }
    
    func nextStatus(_ event : SetupRoundEvent) {
        if event.status == .SetupDone {
            self.questRounds![self.curQuestRoundIdx].delegate = self
            self.questRounds![self.curQuestRoundIdx].nextStatus()
        } else {
            self.setupRound!.nextStatus()
        }
    }
    
   
    func nextStatus(_ event: QuestRoundEvent) {
        if event.status == .Voted && !event.isEventSuccess {
            self.questRounds![self.curQuestRoundIdx].resetQuest()
        } else if event.status == .QuestEnd {
            self.curQuestRoundIdx += 1
            self.questRounds![self.curQuestRoundIdx].delegate = self
            self.questRounds![self.curQuestRoundIdx].nextStatus()
        } else {
            self.questRounds![self.curQuestRoundIdx].nextStatus()
        }
    }
    
    func getKingArther() -> KingArther {
        return kingArther!
    }
    
    func onQuestEventHappend(_ event: QuestRoundEvent) {
        if delegate != nil {
            delegate?.onQuestEventHappend(event)
        }
    }
    
    func onSetupEventHappend(_ event: SetupRoundEvent) {
        if delegate != nil {
            delegate?.onSetupEventHappend(event)
        }
    }
}
