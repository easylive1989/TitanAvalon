import Foundation

class CharacterGenerator {
    func generate(_ users : Array<User>) {
        if users.count < 5 || users.count > 10 {
            return;
        }
        mapUserAndCharacter(users)
    }
    
    func mapUserAndCharacter(_ users : [User]) {
        let characters : [Character] = getCharacterArray(users.count)
        for i in 0..<users.count {
            users[i].character = characters[i]
        }
    }
    
    func getCharacterArray(_ length : Int) -> [Character] {
        let characters = getCharacterArrayByUsers(length)
        var randomCharacterArray: [Character] = []
        while randomCharacterArray.count < length {
            let rand = Int(arc4random_uniform(UInt32(length)))
            if !randomCharacterArray.contains(characters[rand]) {
                randomCharacterArray.append(characters[rand])
            }
        }
        return randomCharacterArray;
    }
    
    func getCharacterArrayByUsers(_ length : Int) -> [Character] {
        if length == 5 {
            return [.Merlin, .Percival, .LsOfArther1, .Morcana, .Assassin]
        } else if length == 6 {
            return [.Merlin, .Percival, .LsOfArther1, .Morcana, .Assassin, .LsOfArther2]
        } else if length == 7 {
            return [.Merlin, .Percival, .LsOfArther1, .Morcana, .Assassin, .LsOfArther2, .Oberon]
        } else if length == 8 {
            return [.Merlin, .Percival, .LsOfArther1, .Morcana, .Assassin, .LsOfArther2, .MsOfMordred, .LsOfArther3]
        } else if length == 9 {
            return [.Merlin, .Percival, .LsOfArther1, .Morcana, .Assassin, .LsOfArther2, .LsOfArther3, .LsOfArther4, .Mordred]
        } else {
            return [.Merlin, .Percival, .LsOfArther1, .Morcana, .Assassin, .LsOfArther2, .LsOfArther3, .LsOfArther4, .Mordred, .Oberon]
        }
    }
}
