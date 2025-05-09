//
//  Animation.swift
//  Revive
//
//  Created by Melanie Laveriano on 4/10/25.
//

import SwiftUI

struct Animation: View {
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.yellow]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 40){
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .frame(width: 200)
                
            }
        }
        .onAppear{
            startLoading()
        }
    }
    private func startLoading(){
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true){ timer in
            if progress >= 1.0{
                timer.invalidate()
            }else{
                progress += 0.01
            }
        }
    }
}

#Preview{
    Animation()
}
