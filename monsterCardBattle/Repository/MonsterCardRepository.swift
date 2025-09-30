//
//  MonsterCardRepository.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/19.
//


import SwiftUI

struct MonsterCardRepository {
    static let defaultCards: [MonsterData] = [
        MonsterData(name: "カードA", atk: 13, df: 5, hp: 10, borderColor: Color(UIColor.cyan)),
        MonsterData(name: "カードB", atk: 5, df: 12, hp: 10, borderColor: Color(UIColor.magenta)),
        MonsterData(name: "カードC", atk: 10, df: 10, hp: 10, borderColor: Color(UIColor.yellow))
    ]
}
