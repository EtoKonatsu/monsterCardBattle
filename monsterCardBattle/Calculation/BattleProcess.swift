//
//  BattleProcess.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import Foundation

class BattleProcess: ObservableObject {
    // MARK: - プロパティ
    @Published var enemyHP: Int
    @Published var playerHP: Int
    @Published var enemyTurnCount: Int
    @Published var damageText: Int? = nil
    @Published var playerDamageText: Int? = nil

    let enemy: EnemyData

    // MARK: - 初期化
    init(enemy: EnemyData, playerHP: Int) {
        self.enemy = enemy
        self.enemyHP = enemy.maxHP
        self.playerHP = playerHP
        self.enemyTurnCount = enemy.enemyTurn
    }

    // MARK: - プレイヤー攻撃処理
    func playerAttack(using card: MonsterData, completion: @escaping () -> Void) {
        // 1️⃣ ダメージ計算
        let attackDamage = BattleCalculation.calculateDamage(
            attackerATK: card.atk,
            defenderDF: enemy.df
        )
        enemyHP = max(enemyHP - attackDamage, 0)
        print("敵に\(attackDamage)ダメージ！ 残りHP: \(enemyHP)")

        // 2️⃣ ダメージ演出
        damageText = attackDamage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.damageText = nil
        }

        // 3️⃣ 敵のターン更新
        let (newCount, shouldEnemyAttack) = BattleCalculation.updateEnemyTurn(
            currentCount: enemyTurnCount,
            interval: enemy.enemyTurn
        )
        enemyTurnCount = newCount

        // 4️⃣ 敵の攻撃が発動する場合
        if shouldEnemyAttack {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                let enemyDamage = BattleCalculation.calculateEnemyAttack(
                    enemyATK: self.enemy.atk,
                    defendingCardDF: card.df
                )
                self.playerHP = max(self.playerHP - enemyDamage, 0)
                print("敵の攻撃！ \(enemyDamage) ダメージを受けた 残りHP: \(self.playerHP)")

                self.playerDamageText = enemyDamage
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.playerDamageText = nil
                }

                completion() // 攻撃処理完了を通知
            }
        } else {
            completion()
        }
    }
}
