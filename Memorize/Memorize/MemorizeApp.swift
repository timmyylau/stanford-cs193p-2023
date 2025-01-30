//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Timmy Lau on 2025-01-29.
//

import SwiftUI

@main
struct MemorizeApp: App {
    
    ///You should only use @StateObject in the place where the ViewModel is first created—likely in your App struct or a parent view.
    ///    •    @StateObject ensures viewModel persists as long as the app runs.
    ///    •    EmojiMemoryGameView does not create the view model but simply receives it.
    
    @StateObject private var game = EmojiMemoryGame() // 👈 Creating the ViewModel here
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game) // Passing it down/
        }
    }
}

