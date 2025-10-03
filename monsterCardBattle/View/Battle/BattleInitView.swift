//
//  BattleInitScene.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI

struct BattleInitView: View {
    @StateObject private var presenter: BattlePresenter

    init(presenter: BattlePresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        ZStack {
            Color(UIColor.darkGray) // 背景全体にグレーを敷く
                .ignoresSafeArea() // 安全領域も含めて全体に
            
            VStack {
                Spacer().frame(height: 50)
                
                // 敵のカード
                EnemyCardView(enemy: presenter.state.enemy)
                    .padding()
                
                // 敵ステータス
                EnemyStatusView(enemy: presenter.state.enemy, damageText: presenter.state.enemyDamagePopup)
                
                Spacer().frame(height: 40)
                
                // プレイヤーのカード群
                HStack {
                    ForEach(presenter.state.cards) { card in
                        MonsterCardView(card: card)
                        .onTapGesture {
                            presenter.selectCard(id: card.id)
                        }
                    }
                    .padding(10)
                }
                
                // プレイヤーステータス + 攻撃ボタン
                PlayerStatusView(
                    player: presenter.state.player,
                    damageText: presenter.state.playerDamagePopup,
                    onAttack: {
                        presenter.attack()
                    }
                )
            }
            // ✅ ゲームクリア
            if presenter.state.result == .win {
                GameResultOverlay(
                    message: "CLEAR!!!",
                    buttonTitle: "クエストに戻る",
                    isWin: true
                ) {
                    print("クエストに戻る")
                }
            }

            // ✅ ゲームオーバー
            if presenter.state.result == .lose {
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
