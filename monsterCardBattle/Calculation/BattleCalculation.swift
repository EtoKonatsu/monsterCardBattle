//
//  BattleCalculation.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import Foundation

struct BattleCalculation {
    /// プレイヤーや敵の攻撃ダメージを計算する
    static func calculateDamage(attackerATK: Int, defenderDF: Int) -> Int {
        return max(attackerATK - defenderDF, 0)
    }

    /// 敵の攻撃ダメージを計算する
    static func calculateEnemyAttack(enemyATK: Int, defendingCardDF: Int) -> Int {
        return max(enemyATK - defendingCardDF, 0)
    }

    /// 敵ターンまでの残りカウントを更新する
    static func updateEnemyTurn(currentCount: Int, interval: Int) -> (newCount: Int, shouldEnemyAttack: Bool) {
        let count = currentCount - 1
        if count <= 0 {
            return (interval, true) // カウントリセット & 敵攻撃フラグON
        } else {
            return (count, false)   // カウント減少、攻撃はしない
        }
    }
}
