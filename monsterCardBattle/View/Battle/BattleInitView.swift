//
//  BattleInitScene.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI

struct BattleInitView: View {
    
    @State private var selectedCard: MonsterData? = nil
    // モンスターデータ
    let monsterCards = MonsterCardRepository.defaultCards

    // BattleProcess を PlayerRepository に任せる
    @StateObject private var manager: BattleProcess

    init() {
        _manager = StateObject(
            wrappedValue: PlayerRepository.createBattleProcess(
                enemy: EnemyRepository.dragon,
                cards: MonsterCardRepository.defaultCards
            )
        )
    }

    // プレイヤーデータ
    var playerStatus: PlayerData {
        PlayerRepository.createDefaultPlayer(using: monsterCards)
            .withCurrentHP(manager.playerHP) // 👈 現在HPを反映
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
            // ✅ ゲームクリア
            if manager.result == .win {
                GameResultOverlay(
                    message: "CLEAR!!!",
                    buttonTitle: "クエストに戻る",
                    isWin: true
                ) {
                    print("クエストに戻る")
                }
            }

            // ✅ ゲームオーバー
            if manager.result == .lose {
                GameResultOverlay(
                    message: "Game Over",
                    buttonTitle: "クエストに戻る",
                    isWin: false
                ) {
                    print("クエストに戻る")
                }
            }

        }
        .navigationBarBackButtonHidden(true)
    }
}
