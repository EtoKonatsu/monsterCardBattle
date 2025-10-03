import SwiftUI

struct BattleViewState {
    struct EnemyInfo {
        let name: String
        let level: Int
        let attack: Int
        let defense: Int
        let maxHP: Int
        let currentHP: Int
        let frameColor: Color
        let remainingTurnText: String
        let isTurnImminent: Bool
    }

    struct PlayerInfo {
        let name: String
        let level: Int
        let maxHP: Int
        let currentHP: Int
    }

    struct CardInfo: Identifiable {
        let id: UUID
        let name: String
        let attack: Int
        let defense: Int
        let frameColor: Color
        let isSelected: Bool
    }

    let enemy: EnemyInfo
    let player: PlayerInfo
    let cards: [CardInfo]
    let enemyDamagePopup: Int?
    let playerDamagePopup: Int?
    let result: BattleResult
}
