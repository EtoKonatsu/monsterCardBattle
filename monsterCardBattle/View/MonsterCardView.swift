//
//  MonsterCardView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct MonsterCardView: View {
    let monsterCards: MonsterData

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

            Text("ATK: \(monsterCards.atk)")
                .foregroundColor(.white)
            Text("DF: \(monsterCards.df)")
                .foregroundColor(.white)
        }
    }
}
