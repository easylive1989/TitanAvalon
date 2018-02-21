//
//  ViewController.swift
//  TitanAvalon
//
//  Created by paulps on 2018/1/17.
//  Copyright © 2018年 paulps. All rights reserved.
//

import UIKit

class GameController: UIViewController, GameDelegate {
    
    let usersMap: [TitanAvalon.Character: User] = [
        .Merlin : User("Apple"),
        .Percival : User("Candy"),
        .LsOfArther1 : User("Dog"),
        .LsOfArther2 : User("Ethan"),
        .LsOfArther3 : User("Frank"),
        .LsOfArther4 : User("Gary"),
        .Assassin : User("Bob"),
        .Morcana : User("Gary"),
        .Oberon : User("Harry"),
        .Mordred : User("Ivan")]
    
    
    func createUsers() -> [User] {
        var users : [User] = []
        for map in usersMap {
            map.value.character = map.key
            users.append(map.value)
        }
        
        for user in users {
            user.relationship = Relationship(user, users)
        }
        
        return users
    }
    
    @IBOutlet weak var consoleOutput: UITextView!
    @IBOutlet weak var inputTextfield: UITextField!
    
    var user : User?
    var users : [User] = []
    var pincode : String = "1234"
    
    var game : Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = createUsers()
        user = users.first{$0.character! == .Percival}
        
        game = Game(users, pincode)
        game!.delegate = self
        game!.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSendClick(_ sender: Any) {
        let inputText = inputTextfield.text
        if inputText!.hasPrefix("/") {
            game!.sendCommand(inputText!)
        }
    }
    
    func printToConsole(_ output: String) {
        DispatchQueue.main.async {
            self.consoleOutput.text = self.consoleOutput.text + "\n\n" + output
        }
    }
    
    fileprivate func nextStatusDelayed(_ event: SetupRoundEvent) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3.0, execute: {
            self.game!.nextStatus(event)
        })
    }
    
    fileprivate func nextStatusDelayed(_ event: QuestRoundEvent) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3.0, execute: {
            self.game!.nextStatus(event)
        })
    }
    
    func onQuestEventHappend(_ event: QuestRoundEvent) {
        printQuestSystemMessage(event)
        if event.isAutoChangeStatus() {
            nextStatusDelayed(event)
        }
    }
    
    func printQuestSystemMessage(_ event: QuestRoundEvent) {
        if event.status == .Assigning {
            printToConsole("King Arther is [" + event.kingArther.name + "]\n" +
                "Please input /assign [name] [name] to assign")
        } else if event.status == .Assigned {
            var executorNames = ""
            for user in event.passive {
                executorNames = executorNames + user.name + " "
            }
            printToConsole("King Arther selects " + executorNames)
        } else if event.status == .Voting {
            printToConsole("Please vote")
        } else if event.status == .Voted {
            printToConsole("Vote " + (event.isEventSuccess ? "Success" : "Failed"))
        } else if event.status == .Executing {
            printToConsole("Please execute")
        } else if event.status == .Executed {
            printToConsole("Quest " + (event.isEventSuccess ? "Success" : "Failed"))
        }
    }
    
    func onSetupEventHappend(_ event: SetupRoundEvent) {
        printSetupSystemMessage(event)
        printSetupPrivateMessage(event)
        nextStatusDelayed(event)
    }
    
    fileprivate func printSetupSystemMessage(_ event: SetupRoundEvent) {
        if event.isPrivateEvent() {
            return
        }
        
        if event.status == .AllCloseEye {
            printToConsole("Everyone close your eyes and extends your hand into a fist in front of you")
        } else if event.status == .EvilsCheck {
            printToConsole("Minions of Mordred open your eyes and look around so that you know all agents of Evils")
        } else if event.status == .EvilsCheckEnd {
            printToConsole("Minions of Mordred close your eyes")
        } else if event.status == .AllCloseEye2 {
            printToConsole("All players should have their eyes closed and hands in a fist in front of them")
        } else if event.status == .EvilsShow {
            printToConsole("Minions of Mordred - extend your thumb so that Merlin will know of you")
        } else if event.status == .MerlinCheck {
            printToConsole("Merlin, open your eyes and see the agents of Evil")
        } else if event.status == .EvilsHide {
            printToConsole("Minions of Mordred - put your thumbs down and re-form your hand into a fist")
        } else if event.status == .MerlinCheckEnd {
            printToConsole("Merlin, close your eyes")
        } else if event.status == .MerlinAndMorcanaShow {
            printToConsole("Merlin and Morcana - extend your thumb so that Percival will know of you")
        } else if event.status == .PercivalCheck {
            printToConsole("Percival, open your eyes and see Merlin and Morcana")
        } else if event.status == .MerlinAndMorcanaHide {
            printToConsole("Merlin and Morcana - put your thumbs down and re-form your hand into a fist")
        } else if event.status == .PercivalCheckEnd {
            printToConsole("Percival, close your eyes")
        } else if event.status == .SetupDone {
            printToConsole("Everyone open your eyes")
        }
    }
    
    fileprivate func printSetupPrivateMessage(_ event: SetupRoundEvent) {
        if !event.isMyEvent(user!) {
            return
        }
        
        if event.status == .EvilsCheck {
            var evils : String = ""
            for user in event.passive {
                evils = evils + user.name + " "
            }
            printToConsole("[you see " + evils + "]")
        } else if event.status == .MerlinCheck {
            var evils : String = ""
            for user in event.passive {
                evils = evils + user.name + " "
            }
            printToConsole("[you see " + evils + "]")
        } else if event.status == .PercivalCheck {
            var merlinAndMorcana : String = ""
            for user in event.passive {
                merlinAndMorcana = merlinAndMorcana + user.name + " "
            }
            printToConsole("[you see " + merlinAndMorcana + "]")
        }
    }
    
}

