//
//  PlayerRepository.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/19.
//


import SwiftUI

struct PlayerRepository {
    static let defaultPlayerName = "こなこな"
    static let defaultLevel = 1

    /// モンスターカードを元にプレイヤーデータを生成
    static func createDefaultPlayer(using cards: [MonsterData]) -> PlayerData {
        let totalHP = cards.reduce(0) { $0 + $1.hp }
        return PlayerData(
            name: defaultPlayerName,
            level: defaultLevel,
            maxHP: totalHP,
            currentHP: totalHP
        )
    }

    /// モンスターカードを元にバトルプロセスを生成
    static func createBattleProcess(enemy: EnemyData, cards: [MonsterData]) -> BattleProcess {
        let totalHP = cards.reduce(0) { $0 + $1.hp }
        return BattleProcess(
            enemy: enemy,
            playerHP: totalHP
        )
    }
}
