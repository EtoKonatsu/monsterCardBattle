//
//  BattleInitScene.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI


struct BattleInitView: View {

    //モンスターデータ
    let monsterCards = [
        MonsterData(name: "カードA", atk: 13, df: 5, hp: 20, borderColor: Color(UIColor.cyan)),
        MonsterData(name: "カードB", atk: 5, df: 12, hp: 20, borderColor: Color(UIColor.magenta)),
        MonsterData(name: "カードC", atk: 10, df: 10, hp: 20, borderColor: Color(UIColor.yellow))
    ]
    // プレイヤーデータ
    var playerStatus: PlayerData {
        let totalHP = monsterCards.reduce(0) { $0 + $1.hp } // ← hpの合計
        return PlayerData(name: "こなこな", level: 1, maxHP: totalHP, currentHP: totalHP)
    }
    // 敵データ
    let enemycard = EnemyData(name: "ドラゴン", level: 8, atk: 13, df: 5, maxHP: 50, currentHP: 40, enemyTurn: 3, borderColor: Color(UIColor.yellow))

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
                    ForEach(monsterCards) { monster in
                        MonsterCardView(monsterCards: monster)
                            .onTapGesture {
                                print("\(monster.name) が選択されました")
                            }
                    }
                    .padding()
                }
                // 敵のステータスエリア
                PlayerStatusView(playerStatus: playerStatus)

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
