//
//  monsterCardBattleApp.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/16.
//

import SwiftUI

@main
struct monsterCardBattleApp: App {
    @StateObject private var dependencyContainer = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.battlePresenterFactory, dependencyContainer.makeBattlePresenter)
        }
    }
}
