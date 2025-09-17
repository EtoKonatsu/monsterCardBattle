//
//  BattleInitScene.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI

struct MonsterCard: Identifiable {
    let id = UUID()
    let name: String
    let atk: Int
    let df: Int
    let borderColor: Color
}

struct BattleInitView: View {
    let cards = [
        MonsterCard(name: "カードA", atk: 13, df: 5, borderColor: .cyan),
        MonsterCard(name: "カードB", atk: 5, df: 12, borderColor: .pink),
        MonsterCard(name: "カードC", atk: 10, df: 10, borderColor: .yellow)
    ]

    var body: some View {
        ZStack {
            Color(UIColor.darkGray) // ← 背景全体にグレーを敷く
                .ignoresSafeArea() // ← 安全領域も含めて全体に
            VStack {
                Text("モンスターカード")
                    .font(.caption)
                    .foregroundColor(.black)
                    .frame(width: 200, height: 200)
                    .background(Color(UIColor.lightGray))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.yellow, lineWidth: 8)
                    )
                Text("敵のステータス")
                    .font(.headline)
                    .foregroundColor(.black)

                HStack {
                    ForEach(cards) { card in
                        VStack {
                            Text("モンスターカード")
                                .font(.caption)
                                .foregroundColor(.black)
                                .frame(width: 100, height: 100)
                                .background(Color(UIColor.lightGray))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(card.borderColor, lineWidth: 8)
                                )

                            Text("ATK: \(card.atk)")
                                .font(.caption2)
                                .foregroundColor(.black)
                            Text("DF: \(card.df)")
                                .font(.caption2)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                }
            }
            //        .padding()
        }
    }
}

struct BattleInitView_Previews: PreviewProvider {
    static var previews: some View {
        BattleInitView()
    }
}
