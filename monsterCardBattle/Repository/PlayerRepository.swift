//
//  PlayerRepository.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/19.
//
import Foundation

struct PlayerRepository: PlayerRepositoryProtocol {
    private let defaultPlayerName = "こなこな"
    private let defaultLevel = 1

    func createDefaultPlayer(maxHP: Int) -> PlayerData {
        PlayerData(
            name: defaultPlayerName,
            level: defaultLevel,
            maxHP: maxHP,
            currentHP: maxHP
        )
    }
}
