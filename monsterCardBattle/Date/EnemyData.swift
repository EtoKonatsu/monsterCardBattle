//
//  EnemyData.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

// 敵モンスターのモデル
struct EnemyData {
    let name: String
    let level: Int
    let atk: Int
    let df: Int
    let maxHP: Int
    var currentHP: Int
    var enemyTurn: Int
}
