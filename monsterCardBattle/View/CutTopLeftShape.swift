//
//  CutTopLeftShape.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/17.
//

import SwiftUI

// 左上を斜めにカットしたシェイプ
struct CutTopLeftShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cutSize: CGFloat = 30 // カットするサイズ

        path.move(to: CGPoint(x: rect.minX + cutSize, y: rect.minY)) // カット始点
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))        // 上辺右
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))        // 右下
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))        // 左下
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cutSize)) // カット下
        path.closeSubpath()

        return path
    }
}
