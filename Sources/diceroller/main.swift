import ArgumentParser
import Foundation

var dieAmount: Int = 1
var dieType: Int = 1
var modifier: Int = 0
var total: Int = 0
var rolledDie: [String] = []

func separateArguments(roll: String) -> (Int, Int, Int) {
    let range = NSRange(location: 0, length: roll.utf16.count)
    let regex = try! NSRegularExpression(pattern: "-")
    let separators = CharacterSet(charactersIn: "d-+")
    let arguments = roll.components(separatedBy: separators)
    let dieAmount = Int(argument: arguments[0]) ?? 1
    let dieType = Int(argument: arguments[1]) ?? 0
    var modifier = 0
    if regex.firstMatch(in: roll, options: [], range: range) != nil {
        modifier -= Int(argument: arguments[2]) ?? 0
    } else {
        modifier += Int(argument: arguments[2]) ?? 0
    }
    print("1: \(String(describing: dieAmount)), 2: \(String(describing: dieType)), 3: \(String(describing: modifier))")
    return (dieAmount, dieType, modifier)
}

func calculateRoll(dieAmount: Int, dieType: Int, modifier: Int) -> Int {
    var calculatedTotal: Int = 0
    for _ in 1...dieAmount {
        let roll = Int.random(in: 1...dieType)
        calculatedTotal += roll
        rolledDie.append("d\(dieType): \(roll)")
    }
    calculatedTotal += modifier
    return calculatedTotal
}

struct NDR: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to roll die",
        subcommands: [Roll.self])
        
        init() { }
}

struct Roll: ParsableCommand {

    public static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to roll die")

    @Argument(help: "What to roll: the amount of die, type of die (and modifier) -> 2d20+6")
    private var rollArguments: String
    
    @Flag(name: .shortAndLong, help: "Show details on roll")
    private var detailed: Bool = false
    
    func run() throws {
        let range = NSRange(location: 0, length: rollArguments.utf16.count)
        let regex = try! NSRegularExpression(pattern: "^[0-9]+d[0-9]+[-+]*[0-9]*")
        if regex.firstMatch(in: rollArguments, options: [], range: range) == nil {
            print("Invalid dice roll, valid roll: 2d12-5.")
            return
        } else {
            (dieAmount, dieType, modifier) = (separateArguments(roll: rollArguments))
            total = calculateRoll(dieAmount: dieAmount, dieType: dieType, modifier: modifier)
            print("Rolling...")
            if detailed {
                print("Rolled d\(dieType) \(dieAmount) times with modifier of \(modifier)")
                print("Individual rolls \(rolledDie)")
            }
            print("Amount rolled: \(total)")
        }
    }
}
    


NDR.main()
