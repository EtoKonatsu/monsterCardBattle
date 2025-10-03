//
//  QuestData.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/10/03.
//

import SwiftUI
import Foundation

struct QuestData: Identifiable {
    let id = UUID()
    let level: DifficultyLevel
}
enum DifficultyLevel {
    case easy
    case normal
    case hard
    case extreme

    var displayName: String {
        switch self {
        case .easy: return "初級クエスト"
        case .normal: return "中級クエスト"
        case .hard: return "上級クエスト"
        case .extreme: return "超級クエスト"
        }
    }

    var color: Color {
        switch self {
        case .easy: return Color(UIColor.cyan)
        case .normal: return Color(UIColor.cyan)
        case .hard: return Color(UIColor.cyan)
        case .extreme: return Color(UIColor.systemPink)
        }
    }
}
