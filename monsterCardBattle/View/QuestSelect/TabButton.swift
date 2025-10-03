//
//  TabButton.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/10/03.
//

import SwiftUI

struct TabButton: View {
    let icon: String
    let label: String
    var isSelected: Bool = false

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
            Text(label)
                .font(.caption)
        }
        .padding(10)
        .frame(width: 70, height: 60)
        .background(isSelected ? Color(UIColor.green) : Color(UIColor.green).opacity(0.5))
        .cornerRadius(30)
        .foregroundColor(.black)
    }
}
    
