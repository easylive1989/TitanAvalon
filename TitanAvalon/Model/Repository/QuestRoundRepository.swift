//
//  SetupRepository.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/11.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation
import Firebase

protocol QuestRoundRepositoryDelegate {
    func onNewStatus(status : QuestStatus)
    func onExecutorAssigned(userNames : [String])
    func onVoted(votes : [Vote])
    func onExecuted(executes : [Execute])
}

protocol IQuestRoundRepository {
    var delegate : QuestRoundRepositoryDelegate? {get set}
    func setStatus(status: QuestStatus)
    func assignExecutor(users : [User])
    func vote(vote : Vote)
    func execute(execute : Execute)
    func clearData()
}

class QuestRoundRepository : IQuestRoundRepository {
    
    fileprivate var statusRef : DatabaseReference
    fileprivate var executorRef : DatabaseReference
    fileprivate var voteRef : DatabaseReference
    fileprivate var executeRef : DatabaseReference
    var delegate : QuestRoundRepositoryDelegate?
    
    init(_ round : Int, _ pincode: String) {
        let ref = Database.database().reference().child(pincode).child("QuestRound").child(String(round))
        
        statusRef = ref.child("status")
        executorRef = ref.child("executor")
        voteRef = ref.child("vote")
        executeRef = ref.child("execute")
        
        statusRef.observe(DataEventType.value, with: onStatusChange)
        executorRef.observe(DataEventType.value, with: onExecutorAssigned)
        voteRef.observe(DataEventType.value, with: onVoted)
        executeRef.observe(DataEventType.value, with: onExecuted)
    }
    
    func setStatus(status: QuestStatus) {
        statusRef.setValue(status.rawValue)
    }
    
    func assignExecutor(users : [User]) {
        for user in users {
            executorRef.childByAutoId().setValue(user.name)
        }
    }
    
    func vote(vote : Vote) {
        voteRef.childByAutoId().setValue(vote.rawValue)
    }
    
    func execute(execute : Execute) {
        executeRef.childByAutoId().setValue(execute.rawValue)
    }
    
    func clearData() {
        executorRef.removeValue()
        voteRef.removeValue()
        executeRef.removeValue()
    }
    
    fileprivate func onStatusChange(snapshot: DataSnapshot) {
        if !snapshot.exists() {
            return
        }
        
        let newStatus = QuestStatus(rawValue: (snapshot.value as? Int)!)
        if delegate != nil {
            delegate?.onNewStatus(status: newStatus!)
        }
    }
    
    fileprivate func onExecutorAssigned(snapshot: DataSnapshot) {
        if !snapshot.exists() {
            return
        }
        
        var userNames : [String] = []
        for child in snapshot.children {
            let childSnapshot = child as! DataSnapshot
            userNames.append(childSnapshot.value as! String)
        }
        
        if delegate != nil {
            delegate?.onExecutorAssigned(userNames: userNames)
        }
    }
    
    fileprivate func onVoted(snapshot: DataSnapshot) {
        if !snapshot.exists() {
            return
        }
        
        var voted : [Vote] = []
        for child in snapshot.children {
            let childSnapshot = child as! DataSnapshot
            voted.append(Vote(rawValue: childSnapshot.value as! Int)!)
        }
        
        if delegate != nil {
            delegate?.onVoted(votes: voted)
        }
    }
    
    fileprivate func onExecuted(snapshot: DataSnapshot) {
        if !snapshot.exists() {
            return
        }
        
        var executed : [Execute] = []
        for child in snapshot.children {
            let childSnapshot = child as! DataSnapshot
            executed.append(Execute(rawValue: childSnapshot.value as! Int)!)
        }
        
        if delegate != nil {
            delegate?.onExecuted(executes: executed)
        }
    }
}


