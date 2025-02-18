//
//  PaletteList.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-17.
//

import SwiftUI

struct EditablePaletteList: View {
//    @EnvironmentObject var store: PaletteStore
    /// no more injectin mode via the @EnviromentObject 
    @ObservedObject var store: PaletteStore
    
    @State private var showCursorPalette = false
    
    var body: some View {
        ///highest level container
        ///
        ///3rd pane issue - we have a navigation stacka dn the NavLink and NavDestination in there are alwasy going to use that stack
        ///we can reuse this entire View, but we cant wrap it in a stack if we want to use the NavaitonSPlitview
        ///good thing - 3 pane, sometimes ytou want the pane to going itno its own stack
//        NavigationStack{
            List {
                ForEach(store.palettes) { palette in
                    /// imporatn arg value, the value that swiftui associated with clicking on that thing.
                    NavigationLink (value: palette.id){
                        VStack(alignment: .leading) {
                            Text(palette.name)
                            Text(palette.emojis)
                                .lineLimit(1)///... at the end of 1 line
                        }
                    }
                }
                .onDelete() { indexSet in
                    ///batch deleting
                    withAnimation {
                        store.palettes.remove(atOffsets: indexSet)
                    }
                }
                .onMove { indexSet, newOffset in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
                
            }
            .navigationDestination(for: Palette.ID.self) { paletteId in
                ///naviationDesingation is outside the lsit, dont attach inside the Text etc, outside the list is where we go
//                PaletteView(palette: palette)
                ///now we need a binding to a palette
                ///Answer: look at my store and find the palette there taht has the same id as the one i just clicked on and pass a binding
                /// when you want to pass a binding to something - sometimes you have to go look it up in your VM
                if let index = store.palettes.firstIndex(where: {$0.id == paletteId}) {
                    PaletteEditor(palette: $store.palettes[index])
                }
            }
            .navigationDestination(isPresented: $showCursorPalette) {
                PaletteEditor(palette: $store.palettes[store.cursorIndex])
            }
            .navigationTitle("\(store.name) Palletes")///doesnt go in the NaviationStack, its on the view
            .toolbar {
                Button {
                    store.insert(name: "", emojis: "")
                    showCursorPalette = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
//    }
}



struct PaletteList: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        ///highest level container
        NavigationStack{
            List(store.palettes) { palette in
                /// imporatn arg value, the value that swiftui associated with clicking on that thing.
                NavigationLink (value: palette.id){
                    Text(palette.name)
                }
            }
            .navigationDestination(for: Palette.self) { palette in
                ///naviationDesingation is outside the lsit, dont attach inside the Text etc, outside the list is where we go
                PaletteView(palette: palette)
            }
            .navigationTitle("\(store.name) Palletes")///doesnt go in the NaviationStack, its on the view
        }
    }
}


struct PaletteView: View {
    var palette: Palette
    
    
    ///notice NavigationStack is not used here, but its in the PaletteList.
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    NavigationLink(value: emoji) {
                        Text(emoji)
                    }
                }
            }
            //            .navigationDestination(for: String.self) { emoji in
            //                Text(emoji)
            //                    .font(.system(size: 300))
            //            }
            Spacer()
        }
        .padding()
        .font(.largeTitle)
        .navigationTitle(palette.name)
    }
}

//
//#Preview {
//    @Previewable @EnvironmentObject var store: PaletteStore
//    PaletteList(store: store)
//}
