//
//  BatrleCalculation.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import Foundation

struct BatrleCalculation {
    /// ダメージを計算する
    /// - Parameters:
    ///   - attackerATK: 攻撃側のATK
    ///   - defenderDF: 防御側のDF
    /// - Returns: 計算されたダメージ値（最低0）
    static func calculateDamage(attackerATK: Int, defenderDF: Int) -> Int {
        return max(attackerATK - defenderDF, 0)
    }
}
