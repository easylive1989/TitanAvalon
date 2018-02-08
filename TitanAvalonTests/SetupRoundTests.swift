import XCTest
@testable import TitanAvalon

class SetupRoundTests: XCTestCase {
    
    var users : [User] = []
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
    
    override func setUp() {
        super.setUp()
        
        users = createUsers()
    }
    
    func testNextStage_Should_ChangeToNextStatus() {
        let setupRound = createSetupRound()
        do {
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .AllCloseEye)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .EvilsCheck)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .EvilsCheckEnd)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .AllCloseEye2)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .EvilsShow)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .MerlinCheck)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .EvilsHide)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .MerlinCheckEnd)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .MerlinAndMorcanaShow)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .PercivalCheck)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .MerlinAndMorcanaHide)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .PercivalCheckEnd)
            try setupRound.nextStage()
            XCTAssertTrue(setupRound.status == .SetupDone)

        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testEvilsCheck_Should_GetEvilsCheckEvent() {
        let evils = users.filter{$0.character!.isEvils()}
        var checkEventMap : [User : SetupRoundEvent] = [:]
        for evil in evils {
            let otherEvils = evils.filter{$0.character!.isEvils() && $0 != evil && $0.character! != .Oberon}
            checkEventMap[evil] = SetupRoundEvent(.EvilsCheck, evil, otherEvils)
        }
        let delegate = TestDelegate(checkEventMap)
        let setupRound = createSetupRound()
        
        do {
            try setupRound.nextStage()  //all close eyes
            setupRound.deletgate = delegate
            try setupRound.nextStage()  //evils check
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testPercivalCheck_Should_GetPercivalCheckEvent() {
        let percival = users.first{$0.character == .Percival}
        let merlinAndMorcana = users.filter{$0.character == .Merlin || $0.character == .Morcana}
        let delegate = TestDelegate([percival! : SetupRoundEvent(.PercivalCheck, percival, merlinAndMorcana )])
        let setupRound = createSetupRound()
        
        do {
            try setupRound.nextStage()  //all close eyes
            try setupRound.nextStage()  //evils check
            try setupRound.nextStage()  //evils check end
            try setupRound.nextStage()  //all close eyes 2
            try setupRound.nextStage()  //evils show
            try setupRound.nextStage()  //merlin check
            try setupRound.nextStage()  //evils hide
            try setupRound.nextStage()  //merlin check end
            try setupRound.nextStage()  //merlin and morcana show
            setupRound.deletgate = delegate
            try setupRound.nextStage()  //percival check
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testMerlinCheck_Should_GetEvilsCheckEvent() {
        let merlin = users.first{$0.character == .Merlin}
        let evils = users.filter{$0.character == .Oberon || $0.character == .Morcana || $0.character == .Assassin || $0.character == .MsOfMordred}
        let delegate = TestDelegate([merlin! : SetupRoundEvent(.MerlinCheck, merlin, evils )])
        let setupRound = createSetupRound()
        
        do {
            try setupRound.nextStage()  //all close eyes
            try setupRound.nextStage()  //evils check
            try setupRound.nextStage()  //evils check end
            try setupRound.nextStage()  //all close eyes 2
            try setupRound.nextStage()  //evils show
            setupRound.deletgate = delegate
            try setupRound.nextStage()  //merlin check
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func createSetupRound() -> SetupRound {
        return SetupRound(users)
    }
    
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
    
    class TestDelegate : SetupRoundDelegate {
        
        var expecteds : [User : SetupRoundEvent]
        
        init(_ expecteds: [User : SetupRoundEvent]) {
            self.expecteds = expecteds
        }
        
        func onSetupEventHappend(_ event: SetupRoundEvent) {
            XCTAssertTrue(expecteds[event.eventActor!] != nil)
            XCTAssertTrue(  expecteds[event.eventActor!]!.status == event.status &&
                            expecteds[event.eventActor!]!.eventActor == event.eventActor &&
                            expecteds[event.eventActor!]!.passive == event.passive)
        }
        
        
    }
}
