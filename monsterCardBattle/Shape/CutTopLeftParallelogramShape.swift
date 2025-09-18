//
//  CutTopLeftShape.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI

// 左上だけ平行四辺形のように斜めにカットしたシェイプ
struct CutTopLeftParallelogramShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let offset: CGFloat = 30 // 斜めにする量

        // 左上を少し右へずらす（平行四辺形の効果）
        path.move(to: CGPoint(x: rect.minX + offset, y: rect.minY)) // 左上（ずらし）
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))       // 右上
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))       // 右下
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))       // 左下
        path.closeSubpath()

        return path
    }
}

