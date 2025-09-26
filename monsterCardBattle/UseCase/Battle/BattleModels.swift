import Foundation

enum BattleResult {
    case none
    case win
    case lose
}

struct BattleSnapshot {
    let enemyHP: Int
    let playerHP: Int
    let enemyTurnCount: Int
    let result: BattleResult
}

struct BattleActionResult {
    let snapshot: BattleSnapshot
    let enemyDamageTaken: Int
    let playerDamageTaken: Int?
    let enemyWillAttackNext: Bool
}
