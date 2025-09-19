//
//  MonsterCardView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct MonsterCardView: View {
    let monsterCards: MonsterData
    let isSelected: Bool // ← 選択されているかどうか

    var body: some View {
        VStack {
            Text("モンスターカード")
                .font(.caption)
                .foregroundColor(.black)
                .frame(width: 100, height: 100)
                .background(Color(UIColor.lightGray))
                .overlay(
                    Rectangle()
                        .stroke(monsterCards.borderColor, lineWidth: 8)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 1)
                        .inset(by: -12) // ← 内側に縮める（隙間を確保）
                        .stroke(isSelected ? Color(UIColor.green) : Color.clear, lineWidth: 5) // ← 選択時だけ枠
                )

            Text("ATK: \(monsterCards.atk)")
                .bold()
                .foregroundColor(.white)
                .padding(.top, 12)
            Text("DF: \(monsterCards.df)")
                .bold()
                .foregroundColor(.white)
        }
    }
}
