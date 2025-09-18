//
//  PlayerStatusView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct PlayerStatusView: View {
    let playerStatus: PlayerData
    let onAttack: () -> Void // 攻撃処理を親から受け取る

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack {
                Text("\(playerStatus.name)  Lv. \(playerStatus.level)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Spacer(minLength: 50)


                Button(action: {
                    print("攻撃ボタンが押されました！")
                    onAttack() // 攻撃処理を実行

                }) {
                    Text("攻撃！")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(Color.red)
                        .clipShape(ParallelogramShape())
                        .shadow(color: .black.opacity(0.8), radius: 3, x: 2, y: 2)
                }
                Spacer()

            }

            // HPゲージ
            HStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 12)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.white, lineWidth: 1)
                        )

                    Rectangle()
                        .fill(Color.green)
                        .frame(width: CGFloat(playerStatus.currentHP) / CGFloat(playerStatus.maxHP) * 250,
                               height: 12)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.white, lineWidth: 2)
                        )
                }
                .frame(width: 250)

                Spacer()

                Text("\(playerStatus.currentHP) / \(playerStatus.maxHP)")
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .padding()
        .frame(width: 350, height: 120)
        .background(Color.black.opacity(0.5))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(UIColor.green), lineWidth: 2)
        )

    }
}
