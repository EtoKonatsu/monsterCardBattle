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
        MonsterCard(name: "カードA", atk: 13, df: 5, borderColor: Color(UIColor.cyan)),
        MonsterCard(name: "カードB", atk: 5, df: 12, borderColor: Color(UIColor.magenta)),
        MonsterCard(name: "カードC", atk: 10, df: 10, borderColor: Color(UIColor.yellow))
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.darkGray) // ← 背景全体にグレーを敷く
                .ignoresSafeArea() // ← 安全領域も含めて全体に
            VStack {
                Spacer().frame(height: 100)
                
                Text("モンスターカード")
                    .foregroundColor(.black)
                    .frame(width: 150, height: 150)
                    .background(Color(UIColor.lightGray))
                    .overlay(
                        Rectangle()
                            .stroke(Color(UIColor.yellow), lineWidth: 8)
                    )
                    .padding()
                
                Text("敵のステータス")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 350, height: 100)
                    .background(Color.black.opacity(0.5))
                    .overlay(
                        Rectangle()
                            .stroke(.white, lineWidth: 2)
                    )
                
                Spacer().frame(height: 40)
                
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
    }
}

struct BattleInitView_Previews: PreviewProvider {
    static var previews: some View {
        BattleInitView()
    }
}
