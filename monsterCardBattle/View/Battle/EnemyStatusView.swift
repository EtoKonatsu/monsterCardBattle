//
//  EnemyStatusView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct EnemyStatusView: View {
    let enemycard: EnemyData
    let currentHP: Int
    let damageText: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(enemycard.name)  Lv. \(enemycard.level)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Text("ATK: \(enemycard.atk)")
                    .foregroundColor(.white)
                Text("DF: \(enemycard.df)")
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
                                .stroke(.white, lineWidth: 1)
                        )

                    Rectangle()
                        .fill(Color.purple)
                        .frame(
                            width: CGFloat(currentHP) / CGFloat(enemycard.maxHP) * 250,
                            height: 12
                        )
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.white, lineWidth: 2)
                        )
                }
                .frame(width: 250, height: 30)
                // 👇 ダメージは別 overlay で中央に配置
                .overlay(
                    Group {
                        if let attackDamage = damageText {
                            DamagePopupView(damage: attackDamage)
                        }
                    },
                    alignment: .center
                )

                Spacer()
                Text("\(currentHP) / \(enemycard.maxHP)")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(width: 350, height: 100)
        .background(Color.black.opacity(0.5))
        .overlay(
            Rectangle()
                .stroke(.white, lineWidth: 2)
        )
    }
}
