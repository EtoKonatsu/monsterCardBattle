//
//  DamagePopupView.swift
//  monsterCardBattle
//
//  Created by 江藤小夏 on 2025/09/18.
//

import SwiftUI

struct DamagePopupView: View {
    let damage: Int

    var body: some View {
        Text("-\(damage)")
            .font(.title)
            .bold()
            .foregroundColor(.red)
            .shadow(color: .black, radius: 2, x: 1, y: 1)
            .scaleEffect(1.2)
            .opacity(1.0)
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 2).combined(with: .opacity), 
                    removal: .opacity
                )
            )
    }
}
