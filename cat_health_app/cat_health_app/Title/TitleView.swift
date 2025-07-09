//
//  TitleView.swift
//  cat_health_app
//
//  Created by 高橋直斗 on 2025/07/09.
//

import SwiftUI

struct TitleView: View {
    
    //@StateObject private var viewModel = TitleViewModel()
    
    var body: some View {
        ZStack {
            Image("paw_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.2),
                    Color.softTiffany.opacity(0.5),
                    Color.white.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("ねこ手帳")
                    .font(.custom("Jiyucho", size: 50))
                
                Spacer()
                
                NavigationLink(destination: CatSelectView()) {
                    Text("ペット選択へ")
                        .font(.custom("Jiyucho", size: 32))
                                    .foregroundColor(.white)
                                    .frame(width: 300, height: 60)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.softTiffany, Color.blue]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(30)
                                    .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)
                                    .bold()
                            }
                .padding()
                
                NavigationLink(destination: CatRegisterView()) {
                    Text("ペット登録へ")
                        .font(.custom("Jiyucho", size: 32))
                                   .foregroundColor(.white)
                                   .frame(width: 300, height: 60)
                                   .background(
                                       LinearGradient(
                                           gradient: Gradient(colors: [Color.softTiffany, Color.blue]),
                                           startPoint: .leading,
                                           endPoint: .trailing
                                       )
                                   )
                                   .cornerRadius(30)
                                   .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)
                                   .bold()
                           }
                .padding()
                
                Spacer()
            }
        }
    }
}


#Preview {
    TitleView()
}
