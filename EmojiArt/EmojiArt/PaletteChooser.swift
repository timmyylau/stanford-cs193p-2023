//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-14.
//

import SwiftUI

struct PaletteChooser: View {
    
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()///views can draw outside its bounds alll the time like background, we say clipped, it stays inside its bounds. so no drawing outside issue.
    }
    
    
    var chooser : some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "➕➖")
            }
            
            ///we add in the role to state that its a destructive button, makes it red by default
            /// has a lable - special view that has title and image, knows how to format it properly
            AnimatedActionButton("Delete", systemImage: "minus", role: .destructive) {
                store.palettes.remove(at: store.cursorIndex)
            }
        }
    }
    
    
    ///transition issue, the hstack is stagnant, to make the view get removed and replaced with another one
    ///give it an ID, now the hstack, its idenitity is part of who it is, comes in with a different ID, the whole view gets replaced
    ///make views come and go by giving them identities
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
}



struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        //self.emojis = emojis.map(String.init)///argumen to map, is a function that takes a character and returns a string, cause argument to map is a fucntion like a closure
        self.emojis = emojis.uniqued.map(String.init)
        //        self.emojis = emojis.uniqued.map { String($0) }
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
        
    }
}



#Preview {
    PaletteChooser()
        .environmentObject(PaletteStore(named: "Preview"))
}
