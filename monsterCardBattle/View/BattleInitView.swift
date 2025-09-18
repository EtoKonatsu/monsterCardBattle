//
//  BattleInitScene.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI

// 敵モンスターのモデル
struct Enemy {
    let name: String
    let level: Int
    let atk: Int
    let df: Int
    let maxHP: Int
    var currentHP: Int
    var enemyTurn: Int
}

struct MonsterCard: Identifiable {
    let id = UUID()
    let name: String
    let atk: Int
    let df: Int
    let borderColor: Color
}



struct BattleInitView: View {
    let cards = [
        MonsterCard(name: "カードA", atk: 13, df: 5, borderColor: Color(UIColor.cyan)),
        MonsterCard(name: "カードB", atk: 5, df: 12, borderColor: Color(UIColor.magenta)),
        MonsterCard(name: "カードC", atk: 10, df: 10, borderColor: Color(UIColor.yellow))
    ]

    // サンプル敵データ
    let enemy = Enemy(name: "ドラゴン", level: 8, atk: 13, df: 5, maxHP: 50, currentHP: 40, enemyTurn: 3)

    var body: some View {
        ZStack {
            Color(UIColor.darkGray) // ← 背景全体にグレーを敷く
                .ignoresSafeArea() // ← 安全領域も含めて全体に
            VStack {
                Spacer().frame(height: 100)

                ZStack(alignment: .topTrailing) {
                    Text("敵のモンスター")
                        .foregroundColor(.black)
                        .frame(width: 150, height: 150)
                        .background(Color(UIColor.lightGray))
                        .overlay(
                            Rectangle()
                                .stroke(Color(UIColor.yellow), lineWidth: 8)
                        )
                        .overlay(
                            // 👇 左上にラベルを重ねる
                            Text("あと\(enemy.enemyTurn)ターン")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    CutTopLeftShape()
                                        .fill(Color.orange)
                                )
                                .offset(x: 4, y: -4), // 枠線にかぶせるよう調整,枠の半分の値
                            alignment: .topTrailing
                        )
                }
                .padding()

                // 敵のステータスエリア
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(enemy.name)
                            .font(.title2)
                            .bold()                            .foregroundColor(.white)
                        Text("Lv. \(enemy.level)")
                            .foregroundColor(.white)
                        Spacer()


                        Text("ATK: \(enemy.atk)")
                            .foregroundColor(.white)
                        Text("DF: \(enemy.df)")
                            .foregroundColor(.white)
                    }


                    HStack {
                        // HPゲージ
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(height: 12)
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white, lineWidth: 1)
                                )

                            Rectangle()
                                .fill(Color.purple)
                                .frame(width: CGFloat(enemy.currentHP) / CGFloat(enemy.maxHP) * 250, height: 12)//現在のHPに応じてHPゲージが変動
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        .frame(width: 250)
                        Spacer()
                        Text("\(enemy.currentHP) / \(enemy.maxHP)")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 350, height: 100)
                .background(Color.black.opacity(0.5))
                .overlay(
                    Rectangle()
                        .stroke(.white, lineWidth: 2)
                )

                Spacer().frame(height: 40)

                //プレイヤーのカード群
                HStack {
                    ForEach(cards) { card in
                        VStack {
                            Text("モンスターカード")
                                .font(.caption)
                                .foregroundColor(.black)
                                .frame(width: 100, height: 100)
                                .background(Color(UIColor.lightGray))
                                .overlay(
                                    Rectangle()
                                        .stroke(card.borderColor, lineWidth: 8)
                                )

                            Text("ATK: \(card.atk)")
                            //                                .font(.caption2)
                                .foregroundColor(.white)
                            Text("DF: \(card.df)")
                            //                                .font(.caption2)
                                .foregroundColor(.white)
                        }
                        // 👇 ここを追加：タップ可能にする
                        .onTapGesture {
                            print("\(card.name) が選択されました")
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
