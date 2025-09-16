//
//  ContentView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {

            Button(action: {
                // 遷移先の処理を書く
            }) {
                Text("モンスターカードバトル")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
