import XCTest
@testable import TitanAvalon

class CharacterGeneratorTests: XCTestCase {
    
    func testGenerate_LessThanFivePeople_Should_Return_Nil() {
        let generator = CharacterGenerator()
        let users : Array<User> = [User("Alice"), User("Bob")]
        let result = generator.generate(users);
        XCTAssertNil(result)
    }
}
