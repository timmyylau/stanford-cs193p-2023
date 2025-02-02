//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Timmy Lau on 2025-01-31.
//

import SwiftUI

///works back and forth
//struct AspectVGrid: Layout {
//struct AspectVGrid<Item>: View where Item: Identifiable {
//struct AspectVGrid<Item: Identifiable, ItemView: View>: View  {
//    /// works with any array of items
//    var items: [Item]
//    var aspectRatio: CGFloat = 1
//    ///give me a fucntion that return a view, 
//    var content: (Item) -> ItemView
//    
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let gridItemSize = gridItemWidthThatFits(
//                count: items.count,
//                size: geometry.size,
//                atAspectRatio: aspectRatio
//            )
//            
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
//                ForEach(items) { item in
//                    content(item)
//                        .aspectRatio(aspectRatio, contentMode: .fit)
//
//                }
//                
//            }
//        }
//    }
//    
//    
//    
//    ///calc the right number to fit
//    /// i have some amount of space offered to me, first imma try 1 colmn and see if it fits, depeding on the aspect ratio
//    /// then 2 columns, same aspect raito, then 3, up to the number of items i have (count)
//    /// adaptive to how many number of cards i have in the game
//    func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat{
//        let count = CGFloat(count)
//        var columnCount = 1.0
//        repeat {
//            /// get W and H of each card given number of columns
//            let width = size.width / columnCount
//            let height = width / aspectRatio
//            /// i now know the width and height of every card if i had that many columns
//            let rowCount = (count / columnCount).rounded(.up)
//            
//            /// swiftui draws on pixel boundaries, vs point boundaries
//            /// rounded to not push over the edge, make sure to not have that extra row
//            if rowCount * height < size.height {
//                return (size.width / columnCount).rounded(.down)
//            }
//            columnCount += 1
//        } while columnCount < count
//        
//        return min(size.width / count, size.height * aspectRatio).rounded(.down)
//        
//    }
//}



//
//  AspectVGrid.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/24/23.
//

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    var aspectRatio: CGFloat = 1
    let content: (Item) -> ItemView
    
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio 
            )
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
