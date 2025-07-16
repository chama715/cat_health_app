//
//  LaunchScreenView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/16.
//

import SwiftUI

struct LaunchScreenWrapper: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                TitleView()
            } else {
                ZStack {
                    Color.white.ignoresSafeArea()
                    Image("Launch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isActive = true
                    }
                }
            }
        }
    }
}
