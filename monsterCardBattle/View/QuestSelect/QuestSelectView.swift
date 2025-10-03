//
//  QuestSelectView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/19.
//


import SwiftUI

struct QuestSelectView: View {
    @Environment(\.battlePresenterFactory) private var makeBattlePresenter
    let player: BattleViewState.PlayerInfo

    // Repository から取得
    private let quests = QuestRepository().fetchQuests()

    var body: some View {
        ZStack {
            Color(UIColor.darkGray).ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer().frame(height: 1)

                // MARK: - プレイヤー情報
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(player.name)  Lv. \(player.level)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }

                    // Exp ゲージ
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.5))
                            .frame(height: 10)
                        Capsule()
                            .fill(Color(UIColor.green))
                            .frame(width: 120, height: 10)
                    }
                }
                .padding()
                .frame(width: 300, height: 80)
                .background(Color.black.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 2)
                )

                // MARK: - クエスト選択ボタン
                VStack(spacing: 20) {
                    ForEach(quests) { quest in
                        QuestButton(title: quest.level.displayName, color: quest.level.color) {
                            BattleInitView(presenter: makeBattlePresenter())
                        }
                    }
                }
                
                Spacer()

                // MARK: - 下部メニュー
                HStack(spacing: 20) {
                    TabButton(icon: "house.fill", label: "ホーム")
                    TabButton(icon: "dumbbell.fill", label: "クエスト", isSelected: true)
                    TabButton(icon: "leaf.fill", label: "育成")
                    TabButton(icon: "gift.fill", label: "ガチャ")
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
