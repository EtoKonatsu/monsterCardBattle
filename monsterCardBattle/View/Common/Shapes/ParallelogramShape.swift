//
//  ParallelogramShape.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct ParallelogramShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let offset: CGFloat = 15 // ← 斜めにずらす量

        path.move(to: CGPoint(x: rect.minX + offset, y: rect.minY)) // 左上を右へ
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))       // 右上
        path.addLine(to: CGPoint(x: rect.maxX - offset, y: rect.maxY)) // 右下を左へ
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))       // 左下
        path.closeSubpath()

        return path
    }
}
