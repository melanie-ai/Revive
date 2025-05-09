//
//  ReviveApp.swift
//  Revive
//
//  Created by Melanie Laveriano on 3/7/25.
//

import SwiftUI

@main
struct ReviveApp: App {
    @State private var animation = true
    var body: some Scene {
        WindowGroup {
            ZStack{
                if animation{
                    Animation()
                } else{
                    MainTabView()
                }
            }
            .animation(.easeInOut(duration: 0.5), value: animation)
                .onAppear(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        animation = false
                    }
                }
        }
    }
}

