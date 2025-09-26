//
//  MonsterData.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//
import Foundation

enum CardFrameStyle: String, CaseIterable, Codable {
    case aqua
    case magenta
    case aurora
    case crimson
    case emerald
    case gold
}

// プレイヤーモンスターのモデル
struct MonsterData: Identifiable, Codable {
    let id: UUID
    let name: String
    let atk: Int
    let df: Int
    let hp: Int
    let frameStyle: CardFrameStyle

    init(id: UUID = UUID(), name: String, atk: Int, df: Int, hp: Int, frameStyle: CardFrameStyle) {
        self.id = id
        self.name = name
        self.atk = atk
        self.df = df
        self.hp = hp
        self.frameStyle = frameStyle
    }
}
