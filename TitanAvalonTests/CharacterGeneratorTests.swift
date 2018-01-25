import XCTest
@testable import TitanAvalon

class CharacterGeneratorTests: XCTestCase {
    
    func testGenerate_LessThanFiveUsers_Should_Return_Nil() {
        should_return_null([User("Alice"),
                            User("Bob")])
    }
    
    func testGenerate_MoreThanTenUsers_Should_Return_Nil() {
        should_return_null([User("Alice"),
                            User("Bob"),
                            User("Cathy"),
                            User("David"),
                            User("Ethan"),
                            User("Frank"),
                            User("Garry"),
                            User("Hank"),
                            User("Ivan"),
                            User("Jack"),
                            User("Ken")])
    }
    
    func testGenerate_FiveUsers_Should_Return_CharacterList() {
        assertUsersAndCharacters([User("Alice"),
                                  User("Bob"),
                                  User("Cathy"),
                                  User("David"),
                                  User("Ethan")])
    }
    
    func testGenerate_SixUsers_Should_Return_CharacterList() {
        assertUsersAndCharacters([User("Alice"),
                                  User("Bob"),
                                  User("Cathy"),
                                  User("David"),
                                  User("Ethan"),
                                  User("Frank")])
    }
    
    func testGenerate_SevenUsers_Should_Return_CharacterList() {
        assertUsersAndCharacters([User("Alice"),
                                  User("Bob"),
                                  User("Cathy"),
                                  User("David"),
                                  User("Ethan"),
                                  User("Frank"),
                                  User("Garry")])
    }
    
    func testGenerate_EightUsers_Should_Return_CharacterList() {
        assertUsersAndCharacters([User("Alice"),
                                  User("Bob"),
                                  User("Cathy"),
                                  User("David"),
                                  User("Ethan"),
                                  User("Frank"),
                                  User("Garry"),
                                  User("Hank")])
    }
    
    func testGenerate_NineUsers_Should_Return_CharacterList() {
        assertUsersAndCharacters([User("Alice"),
                                  User("Bob"),
                                  User("Cathy"),
                                  User("David"),
                                  User("Ethan"),
                                  User("Frank"),
                                  User("Garry"),
                                  User("Hank"),
                                  User("Ivan")])
    }
    
    func testGenerate_TenUsers_Should_Return_CharacterList() {
        assertUsersAndCharacters([User("Alice"),
                                  User("Bob"),
                                  User("Cathy"),
                                  User("David"),
                                  User("Ethan"),
                                  User("Frank"),
                                  User("Garry"),
                                  User("Hank"),
                                  User("Ivan"),
                                  User("Jack")])
    }
    
    func should_return_null(_ actualUsers : [User]) {
        let generator = createCharacterGenerator()
        generator.generate(actualUsers);
        for user in actualUsers {
            XCTAssertNil(user.character)
        }
    }
    
    func assertUsersAndCharacters(_ actualUsers : [User]) {
        let generator = createCharacterGenerator()
        generator.generate(actualUsers);
        for user in actualUsers {
            XCTAssertNotNil(user.character)
        }
    }

    func createCharacterGenerator() -> CharacterGenerator {
        return CharacterGenerator();
    }
}
