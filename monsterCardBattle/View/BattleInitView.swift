//
//  BattleInitScene.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI

struct BattleInitView: View {
    
    @State private var selectedCard: MonsterData? = nil
    @StateObject private var manager = BattleProcess(
        enemy: EnemyData(name: "ドラゴン", level: 8, atk: 13, df: 5, maxHP: 50, currentHP: 50, enemyTurn: 4, borderColor: .yellow),
        playerHP: 60
    )
    
    //モンスターデータ
    let monsterCards = [
        MonsterData(name: "カードA", atk: 13, df: 5, hp: 20, borderColor: Color(UIColor.cyan)),
        MonsterData(name: "カードB", atk: 5, df: 12, hp: 20, borderColor: Color(UIColor.magenta)),
        MonsterData(name: "カードC", atk: 10, df: 10, hp: 20, borderColor: Color(UIColor.yellow))
    ]
    
    // プレイヤーデータ
    var playerStatus: PlayerData {
        let totalHP = monsterCards.reduce(0) { $0 + $1.hp } // ← hpの合計
        return PlayerData(name: "こなこな", level: 1, maxHP: totalHP, currentHP: manager.playerHP)
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.darkGray) // 背景全体にグレーを敷く
                .ignoresSafeArea() // 安全領域も含めて全体に
            
            VStack {
                Spacer().frame(height: 100)
                
                // 敵のカード
                EnemyCardView(enemycard: manager.enemy, remainingTurns: manager.enemyTurnCount)
                    .padding()
                
                // 敵ステータス
                EnemyStatusView(enemycard: manager.enemy, currentHP: manager.enemyHP, damageText: manager.damageText)
                
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
                    damageText: manager.playerDamageText,
                    onAttack: {
                        if let card = selectedCard {
                            manager.playerAttack(using: card) {
                                // 攻撃後に必要な処理があればここに
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
