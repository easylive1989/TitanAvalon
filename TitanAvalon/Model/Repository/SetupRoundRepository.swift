//
//  SetupRepository.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/11.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation
import Firebase

protocol SetupRoundRepositoryDelegate {
    func onNewStatus(status : SetupStatus)
}

protocol ISetupRoundRepository {
    var delegate : SetupRoundRepositoryDelegate? {get set}
    func setStatus(status: SetupStatus)
}

class SetupRoundRepository : ISetupRoundRepository {
    
    fileprivate var ref : DatabaseReference
    var delegate : SetupRoundRepositoryDelegate?
    
    init(pincode: String) {
        ref = Database.database().reference().child(pincode).child("SetupRound")
        ref.observe(DataEventType.value, with: onStatusChange)
    }
    
    func setStatus(status: SetupStatus) {
        ref.setValue(status.rawValue)
    }
    
    fileprivate func onStatusChange(snapshot: DataSnapshot) {
        let newStatus = SetupStatus(rawValue: (snapshot.value as? Int)!)
        if delegate != nil {
            delegate?.onNewStatus(status: newStatus!)
        }
    }
}

