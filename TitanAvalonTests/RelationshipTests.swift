
import XCTest
@testable import TitanAvalon

class RelationshipTests: XCTestCase {
    
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
    
    func testMerlin_Should_SeeEvils_Except_Mordred() {
        let relationship = getRelationship(character: TitanAvalon.Character.Merlin)
        
        let actual = relationship.canSee()
        
        let expected = getUser(characters: .Assassin, .Morcana, .Oberon)
        
        isSameCharacter(actual, expected)
    }
    
    func testOberon_Should_Not_SeeEvils() {
        let relationship = getRelationship(character: TitanAvalon.Character.Oberon)
        
        let actual = relationship.canSee()
        
        isSameCharacter(actual, [])
    }
    
    func testPercival_Should_SeeMerlinAndMorcana() {
        let relationship = getRelationship(character: TitanAvalon.Character.Percival)
        
        let actual = relationship.canSee()
        
        let expected = getUser(characters: .Merlin, .Morcana)
        
        isSameCharacter(actual, expected)
    }
    
    func testOtherEvils_Should_SeeEvils_Except_Oberon() {
        let relationship = getRelationship(character: TitanAvalon.Character.Morcana)
        
        let actual = relationship.canSee()
        
        let expected = getUser(characters: .Mordred, .Morcana, .Assassin)
        
        isSameCharacter(actual, expected)
    }
    
    func testOtherGoods_Should_Not_SeeEvils() {
        let relationship = getRelationship(character: TitanAvalon.Character.LsOfArther1)
        let actual = relationship.canSee()
        isSameCharacter(actual, [])
    }
    
    func isSameCharacter(_ actual: [User],_ expected: [User]) {
        var isSame = true
        if actual.count != expected.count {
            isSame = false
        }
        
        for user in actual {
            if !expected.contains(user) {
                isSame = false
            }
        }
        
        XCTAssertTrue(isSame)
    }
    
    func getUser(characters : TitanAvalon.Character...) -> [User] {
        return Array(usersMap.filter{ characters.contains($0.value.character!) }.values)
    }
    
    func getRelationship(character: TitanAvalon.Character) -> Relationship {
        let users = createUser()
        let targetUser = users.filter{$0.character == character}
        return Relationship(targetUser[0], users)
    }
    
    func createUser() -> [User] {
        var users : [User] = []
        
        for map in usersMap {
            map.value.character = map.key
            users.append(map.value)
        }
        
        return users
    }
    
}


