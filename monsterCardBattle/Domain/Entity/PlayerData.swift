//
//  PlayerData.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//
import Foundation

// プレイヤーのデータ
struct PlayerData: Identifiable {
    var id = UUID()
    let name: String
    let level: Int
    let maxHP: Int
    var currentHP: Int
}

extension PlayerData {
    func withCurrentHP(_ hp: Int) -> PlayerData {
        return PlayerData(name: name, level: level, maxHP: maxHP, currentHP: hp)
    }
}
