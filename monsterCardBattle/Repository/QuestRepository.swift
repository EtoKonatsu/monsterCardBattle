//
//  QuestRepository.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/10/03.
//

import Foundation

protocol QuestRepositoryProtocol {
    func fetchQuests() -> [QuestData]
}

struct QuestRepository: QuestRepositoryProtocol {
    func fetchQuests() -> [QuestData] {
        return [
            QuestData(level: .easy),
            QuestData(level: .normal),
            QuestData(level: .hard),
            QuestData(level: .extreme)
        ]
    }
}
