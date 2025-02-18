//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Timmy Lau on 2025-02-17.
//

import SwiftUI
///manage all the palette in all the stores
struct PaletteManager: View {
    
    let stores: [PaletteStore]
    @State private var selectedStore: PaletteStore?/// ? if you want to allow nothing to be selected, otherwise give a starting value
    
    
    var body: some View {
        NavigationSplitView {
            List(stores, selection: $selectedStore) { store in
                /// bad!!, because this store we are shwoing the name of, is not held in an @ObservedObeject in the PaletteManager, it was passed to us
                /// disciplinde - only accessing the vars of an obserableoject form a var that is marked, @ObeserbedObject or @Environ,ment object
                /// otherwise we dont get the @obserbedobject behavior - when one of the @obserbedobject @Published vars changes our view might have to dedraw itself
                /// bad form - to access an ObservObjects var from a var that is not marked @Observedobject
                /// Fix: create another vie w PaletteStoreview and pass this store into an @ObservedObject var in that view and it can show the name
                ///
                //  Text(store.name) // bad!!
                // this is "bad" because store is not an @ObservedObject in this View
                // instead, pass the store onto another View's @ObservedObject (as below)
                // this is not ACTUALLY a problem for PaletteStore's name var
                // because it's not @Published anyway (and furthermore is a let constant)
                // but be careful of this case where an ObservableObject
                // is passed to a View not via @ObservableObject or @EnvironmentObject
                // (it's passed to PaletteManager via an [PaletteStore])
//                Text(store.name)
//                    .tag(store.name)///have to match type with $selectedStore
                PaletteStoreView(store: store)
                    .tag(store)
            }
        } content: {
            if let selectedStore {
                EditablePaletteList(store: selectedStore)
            }
            Text("Choose a store")
        } detail:  {
            Text("Choose a palette")
        }
    }
}

struct PaletteStoreView: View {
    @ObservedObject var store: PaletteStore
    var body: some View {
        Text(store.name)
    }
}




struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager(stores: [PaletteStore(named: "Preview1"),PaletteStore(named: "Preview2")])
    }
}
