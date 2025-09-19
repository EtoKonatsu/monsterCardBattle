//
//  EnemyRepository.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/19.
//

import SwiftUI

struct EnemyRepository {
    static let dragon = EnemyData(
        name: "ドラゴン",
        level: 8,
        atk: 13,
        df: 5,
        maxHP: 50,
        currentHP: 50,
        enemyTurn: 4,
        borderColor: .yellow
    )
}
