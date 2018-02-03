import Foundation

enum Character {
    case Merlin
    case Percival
    case Morcana
    case Assassin
    case LsOfArther1
    case LsOfArther2
    case LsOfArther3
    case LsOfArther4
    case Oberon
    case MsOfMordred
    case Mordred
    
    func isEvils() -> Bool {
        return self == .Morcana || self == .Assassin || self == .MsOfMordred || self == .Mordred || self == .Oberon
    }
    
}
