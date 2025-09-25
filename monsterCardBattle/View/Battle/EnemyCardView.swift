//
//  EnemyCardView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct EnemyCardView: View {
    let enemy: BattleViewState.EnemyInfo

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(enemy.name)
                .foregroundColor(.black)
                .frame(width: 150, height: 150)
                .background(Color(UIColor.lightGray))
                .overlay(
                    Rectangle()
                        .stroke(enemy.frameColor, lineWidth: 8)
                )
                .overlay(
                    Text(enemy.remainingTurnText)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .trailing) // ← 幅を確保して右寄せ
                        .multilineTextAlignment(.trailing)       // ← テキスト右寄せ
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            CutTopLeftParallelogramShape()
                                .fill(enemy.isTurnImminent ? Color.red : Color.orange)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 2, y: 2) // ← 影を追加
                        .offset(x: 4, y: -4), // ← 枠に少しかぶせる
                    alignment: .topTrailing // ← 左上に配置（右寄せはテキスト内部で制御）
                )

        }
    }
}
