//
//  Weather4CastApp.swift
//  Weather4Cast
//
//  Created by Avishka Amunugama on 5/21/22.
//

import SwiftUI

@main
struct Weather4CastApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(
                    Image("AppBackground")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )
        }
    }
}
