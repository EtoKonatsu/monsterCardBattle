//
//  QuestSelectView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/19.
//

import SwiftUI

struct QuestSelectView: View {
    var body: some View {
        ZStack {
            Color(UIColor.darkGray).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("クエスト選択")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                NavigationLink("初級クエスト") {
                    BattleInitView() // ← バトル画面へ
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                // 後で中級・上級を追加してもOK
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
