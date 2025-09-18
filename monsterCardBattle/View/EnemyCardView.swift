//
//  EnemyCardView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct EnemyCardView: View {
    let enemycard: EnemyData

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text("敵のモンスター")
                .foregroundColor(.black)
                .frame(width: 150, height: 150)
                .background(Color(UIColor.lightGray))
                .overlay(
                    Rectangle()
                        .stroke(.yellow, lineWidth: 8)
                )
                .overlay(
                    Text("あと\(enemycard.enemyTurn)ターン")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(
                            CutTopLeftShape().fill(.orange)
                        )
                        .offset(x: 4, y: -4),
                    alignment: .topTrailing
                )
        }
    }
}
