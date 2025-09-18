//
//  BattleInitScene.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI

struct BattleInitView: View {
    @State private var selectedCard: MonsterData? = nil
    @State private var enemyHP: Int = 50
    @State private var damageText: Int? = nil


    //モンスターデータ
    let monsterCards = [
        MonsterData(name: "カードA", atk: 13, df: 5, hp: 20, borderColor: Color(UIColor.cyan)),
        MonsterData(name: "カードB", atk: 5, df: 12, hp: 20, borderColor: Color(UIColor.magenta)),
        MonsterData(name: "カードC", atk: 10, df: 10, hp: 20, borderColor: Color(UIColor.yellow))
    ]
    // 敵データ
    let enemycard = EnemyData(name: "ドラゴン", level: 8, atk: 13, df: 5, maxHP: 50, currentHP: 50, enemyTurn: 3, borderColor: Color(UIColor.yellow))
    // プレイヤーデータ
    var playerStatus: PlayerData {
        let totalHP = monsterCards.reduce(0) { $0 + $1.hp } // ← hpの合計
        return PlayerData(name: "こなこな", level: 1, maxHP: totalHP, currentHP: totalHP)
    }

    var body: some View {
        ZStack {
            Color(UIColor.darkGray) // 背景全体にグレーを敷く
                .ignoresSafeArea() // 安全領域も含めて全体に

            VStack {
                Spacer().frame(height: 100)

                // 敵のカード（右上にターンラベル付き）
                EnemyCardView(enemycard: enemycard)
                    .padding()

                // 敵ステータス（現在のHPを反映）
                EnemyStatusView(enemycard: enemycard, currentHP: enemyHP, damageText: damageText)

                Spacer().frame(height: 40)

                // プレイヤーのカード群
                HStack {
                    ForEach(monsterCards) { monster in
                        MonsterCardView(
                            monsterCards: monster,
                            isSelected: selectedCard?.id == monster.id // ← 選択判定を渡す
                        )
                        .onTapGesture {
                            selectedCard = monster
                            print("\(monster.name) を選択しました")
                        }
                    }
                    .padding(10)
                }

                // プレイヤーステータス + 攻撃ボタン
                PlayerStatusView(
                    playerStatus: playerStatus,
                    onAttack: {
                        if let card = selectedCard {
                            // ✅ ダメージ計算を BattleLogic に任せる
                            let attackDamage = BatrleCalculation.calculateDamage(
                                attackerATK: card.atk,
                                defenderDF: enemycard.df
                            )

                            // 敵HPを減らす
                            enemyHP = max(enemyHP - attackDamage, 0)
                            print("敵に\(attackDamage)ダメージ！ 残りHP: \(enemyHP)")

                            // ダメージ表示を出す
                            withAnimation(.easeOut(duration: 0.2)) {
                                damageText = attackDamage
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    damageText = nil
                                }
                            }
                        } else {
                            print("カードが選ばれていません！")
                        }
                    }
                )

            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
