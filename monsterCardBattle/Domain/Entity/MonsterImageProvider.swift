//
//  MonsterImageProvider.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/10/03.
//

import Foundation

struct MonsterImageProvider {
    static func imageName(for card: BattleViewState.CardInfo) -> String {
        switch card.name {
        case "カードA": return "monster_card_a"
        case "カードB": return "monster_card_b"
        case "カードC": return "monster_card_c"
        default: return "monster_placeholder"
        }
    }
}
