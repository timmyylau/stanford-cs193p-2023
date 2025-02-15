//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-13.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")///PalleteStore VM is used everywhere in the app, so all over, all documents, same palette store,

    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore)///pass via EnviromentObject -> deep into view hierachies, inject into entire app
            /// we can only have one PaletteStore injected in, cause theres no way to say which one, the injection thing only works when you have ONE thing of a certain type
        }
    }
}
