//
//  BattleInitScene.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI


struct BattleInitView: View {
    let monsterCards = [
        MonsterData(name: "カードA", atk: 13, df: 5, borderColor: Color(UIColor.cyan)),
        MonsterData(name: "カードB", atk: 5, df: 12, borderColor: Color(UIColor.magenta)),
        MonsterData(name: "カードC", atk: 10, df: 10, borderColor: Color(UIColor.yellow))
    ]

    // サンプル敵データ
    let enemycard = EnemyData(name: "ドラゴン", level: 8, atk: 13, df: 5, maxHP: 50, currentHP: 40, enemyTurn: 3)

    var body: some View {
        ZStack {
            Color(UIColor.darkGray) // ← 背景全体にグレーを敷く
                .ignoresSafeArea() // ← 安全領域も含めて全体に
            VStack {
                Spacer().frame(height: 100)

                // 敵のカード（右上にターンラベル付き）
                EnemyCardView(enemycard: enemycard)
                .padding()

                // 敵のステータスエリア
                EnemyStatusView(enemycard: enemycard)

                Spacer().frame(height: 40)

                // プレイヤーのカード群
                HStack {
                    ForEach(monsterCards) { monsterCards in
                        MonsterCardView(monsterCards: monsterCards)
                            .onTapGesture {
                                print("\(monsterCards.name) が選択されました")
                            }
                    }
                    .padding()
                }

                Text("プレイヤーのステータス")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 350, height: 150)
                    .background(Color.black.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(UIColor.green), lineWidth: 2)
                    )
            }

        }
        .navigationBarBackButtonHidden(true) // ← 戻るボタンを隠す
    }
}

struct BattleInitView_Previews: PreviewProvider {
    static var previews: some View {
        BattleInitView()
    }
}
