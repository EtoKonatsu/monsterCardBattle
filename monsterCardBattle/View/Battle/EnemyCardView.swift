//
//  EnemyCardView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct EnemyCardView: View {
    let enemycard: EnemyData
    let remainingTurns: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text("敵のモンスター")
                .foregroundColor(.black)
                .frame(width: 150, height: 150)
                .background(Color(UIColor.lightGray))
                .overlay(
                    Rectangle()
                        .stroke(enemycard.borderColor, lineWidth: 8)
                )
                .overlay(
                    Text("あと\(remainingTurns - 1)ターン")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .trailing) // ← 幅を確保して右寄せ
                        .multilineTextAlignment(.trailing)       // ← テキスト右寄せ
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            CutTopLeftParallelogramShape()
                                .fill(remainingTurns <= 1 ? Color.red : Color.orange) // ← 1ターンなら赤
                        )
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 2) // ← 影を追加
                        .offset(x: 4, y: -4), // ← 枠に少しかぶせる
                    alignment: .topTrailing // ← 左上に配置（右寄せはテキスト内部で制御）
                )

        }
    }
}
