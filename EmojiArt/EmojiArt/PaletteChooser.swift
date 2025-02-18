//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-14.
//

import SwiftUI

struct PaletteChooser: View {
    
    /// the $store.palette works for @EnvironmentObject because the binding/projectedvalue/$ is a binding to that VM,
    @EnvironmentObject var store: PaletteStore
    @State private var showPaletteEditor = false
    @State private var showPaletteList   = false

    var body: some View {
        HStack {
            chooser
//                .popover(isPresented: $showPaletteEditor) {
//                    ///popover points/positions itself to where you add the .
//                    PaletteEditor()
//                }
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()///views can draw outside its bounds alll the time like background, we say clipped, it stays inside its bounds. so no drawing outside issue.
        .sheet(isPresented: $showPaletteEditor) {
            ///binding to the source of truth, changes are in the source. 
            PaletteEditor(palette: $store.palettes[store.cursorIndex])
                .font(nil)///go back to the default font, ignore what the other people said the font was
        }
        .sheet(isPresented: $showPaletteList) {
//            EditablePaletteList()///took this out due to changeing in PaletteList from @ENiromentObject to @ObservableObject now have to pass the store.
            
            ///have to add NaviationStack here because it was removed in PaletteList .
            ///it also shows -  that NavigationStack can be a  high hieracical level, notice the nvaitaionlink and destinations arent here butit still works cause its nested 
            NavigationStack {
                EditablePaletteList(store: store)
                    .font(nil)
            }
         
        }
    }
    
    
    var chooser : some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu {
            gotoMenu
            
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "", emojis: "")
                showPaletteEditor = true
            }
            
            ///we add in the role to state that its a destructive button, makes it red by default
            /// has a lable - special view that has title and image, knows how to format it properly
            AnimatedActionButton("Delete", systemImage: "minus", role: .destructive) {
                store.palettes.remove(at: store.cursorIndex)
            }
            
            AnimatedActionButton("Edit", systemImage: "pencil") {
                showPaletteEditor = true
            }
            AnimatedActionButton("List", systemImage: "list.bullet.rectangle.portrait") {
                showPaletteList = true
            }
        }
    }
    
    
    ///changes the store.cursor index to the chosen palette
    private var gotoMenu: some View {
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(palette.name) {
                    if let index = store.palettes.firstIndex(where: {$0.id == palette.id}) {
                        store.cursorIndex = index
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
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
