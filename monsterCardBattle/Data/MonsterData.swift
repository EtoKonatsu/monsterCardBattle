//
//  MonsterData.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//
import SwiftUI

// プレイヤーモンスターのモデル
struct MonsterData: Identifiable {
    let id = UUID()
    let name: String
    let atk: Int
    let df: Int
    let hp: Int
    let borderColor: Color//属性型に変更する。enumとか使う
}
