//
//  ContentView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/16.
//

import SwiftUI

struct ContentView: View {
    @State private var goBattle = false
    @Environment(\.battlePresenterFactory) private var makeBattlePresenter

    var body: some View {
        NavigationStack { // ← NavigationStack が必要！
            ZStack {
                Color(UIColor.darkGray)
                    .ignoresSafeArea()

                VStack {
                    Text("モンスターカードバトル")
                        .font(.title2)
                        .foregroundColor(.white)

                    Button(action: {
                        goBattle = true // ボタン押下で遷移フラグをON
                    }) {
                        Text("スタート！")
                            .font(.title2)
                            .padding()
                            .background(Color(UIColor.green))
                            .foregroundColor(.black)
                            .bold()
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            // 👇 NavigationStack 内に navigationDestination を置く
            .navigationDestination(isPresented: $goBattle) {
                let presenter = makeBattlePresenter()
                QuestSelectView(player: presenter.state.player)
            }
        }
    }
}

#Preview {
    ContentView()
}
