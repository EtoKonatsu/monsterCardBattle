//
//  QuestButton.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/10/03.
//

import SwiftUI

struct QuestButton<Destination: View>: View {
    let title: String
    let color: Color
    let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            Text(title)
                .font(.headline)
                .bold()
                .foregroundColor(.black)
                .padding(.vertical, 12)
                .frame(width: 250)
                .background(
                    ParallelogramShape()
                        .fill(color)
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 3, y: 3)
                )
        }
    }
}
