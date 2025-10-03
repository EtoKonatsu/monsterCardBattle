//
//  MonsterCardView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct MonsterCardView: View {
    let card: BattleViewState.CardInfo

    var body: some View {
        VStack {
            // モンスター画像
            Image(MonsterImageProvider.imageName(for: card))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .background(Color.black)
                .overlay(
                    Rectangle()
                        .stroke(card.frameColor, lineWidth: 8)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 1)
                        .inset(by: -12)
                        .stroke(card.isSelected ? Color.green : Color.clear, lineWidth: 5)
                )

            Text("ATK: \(card.attack)")
                .bold()
                .foregroundColor(.white)
                .padding(.top, 12)
            Text("DF: \(card.defense)")
                .bold()
                .foregroundColor(.white)
        }
    }
}
