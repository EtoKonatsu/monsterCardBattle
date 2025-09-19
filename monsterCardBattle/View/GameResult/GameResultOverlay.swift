//
//  GameResultOverlay.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/19.
//


import SwiftUI

struct GameResultOverlay: View {
    let message: String
    let buttonTitle: String
    let isWin: Bool
    let onButtonTap: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 20) {
                // 平行四辺形 + モザイク柄
                ZStack {
                    MosaicPattern(color: isWin ? Color(UIColor.green) : Color(UIColor.red)) // ← 勝利なら緑、負けなら赤
                        .mask(ParallelogramShape())            // 平行四辺形で切り抜き

                    ParallelogramShape()
                        .stroke(isWin ? Color.green : Color.red, lineWidth: 4)

                    Text(message)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .shadow(color: .white, radius: 1, x: 1, y: 1)
                }
                .frame(width: 280, height: 80)

                // 「クエストに戻る」ボタン
                Button(action: {
                    dismiss() // 👈 タイトル画面に戻る
                    onButtonTap()
                }) {
                    Text(buttonTitle)
                        .font(.title2)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 2, y: 2)
                }
            }
        }
    }
}

// ✅ モザイク柄（濃淡2色）
struct MosaicPattern: View {
    var color: Color
    var seed: Int = 42 // ← ランダムの種（固定すると毎回同じ模様）

    var body: some View {
        GeometryReader { geo in
            let size: CGFloat = 3 // ← タイルを小さめにして本物感
            let rows = Int(geo.size.height / size)
            let cols = Int(geo.size.width / size)

            ZStack {
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<cols, id: \.self) { col in
                        let rng = (row * cols + col + seed).hashValue
                        let opacity = Double((rng % 40) + 60) / 100.0
                        Rectangle()
                            .fill(color.opacity(opacity))
                            .frame(width: size, height: size)
                            .position(
                                x: CGFloat(col) * size + size / 2,
                                y: CGFloat(row) * size + size / 2
                            )
                    }
                }
            }
        }
        .clipped()
    }
}
