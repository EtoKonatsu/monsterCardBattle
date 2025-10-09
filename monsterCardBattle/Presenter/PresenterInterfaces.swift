//
//  PresenterInterfaces.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/10/09.
//

import Foundation

protocol BattlePresenterProtocol: ObservableObject {
    var state: BattleViewState { get }
    func selectCard(id: UUID)
    func attack()
    func reset()
}
