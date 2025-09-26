//
//  EnemyData.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import Foundation

// 敵モンスターのモデル
struct EnemyData: Codable {
    let id: UUID
    let name: String
    let level: Int
    let atk: Int
    let df: Int
    let maxHP: Int
    var currentHP: Int
    var enemyTurn: Int
    let frameStyle: CardFrameStyle

    init(
        id: UUID = UUID(),
        name: String,
        level: Int,
        atk: Int,
        df: Int,
        maxHP: Int,
        currentHP: Int,
        enemyTurn: Int,
        frameStyle: CardFrameStyle
    ) {
        self.id = id
        self.name = name
        self.level = level
        self.atk = atk
        self.df = df
        self.maxHP = maxHP
        self.currentHP = currentHP
        self.enemyTurn = enemyTurn
        self.frameStyle = frameStyle
    }
}
