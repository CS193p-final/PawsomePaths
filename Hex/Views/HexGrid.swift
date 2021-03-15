//
//  HexGrid.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct HexGrid<Item, ID, ItemView>: View where Item: Identifiable, ID: Hashable, ItemView: View{
    private var items: [Item]
    private let cols: Int
    private var id: KeyPath<Item,ID>
    private var viewForItems: (Item) -> ItemView
        
    init(_ items: [Item], cols: Int, id: KeyPath<Item, ID>, viewForItems: @escaping (Item) -> ItemView) {
        self.items = items
        self .cols = cols
        self.id = id
        self.viewForItems = viewForItems
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItems = Array(repeating: GridItem(.fixed(hexagonWidth(geometry.size.width)), spacing: 0), count: cols)
                ZStack {
                    BlueBorder(cols: cols, frameHeight: hexagonHeight(geometry.size.width), frameWidth: hexagonWidth(geometry.size.width))
                        .offset(x: xOffsetRightBlueBorder(geometry.size.width))

                    BlueBorder(cols: cols, frameHeight: hexagonHeight(geometry.size.width), frameWidth: hexagonWidth(geometry.size.width))
                        .offset(x: xOffsetLeftBlueBorder(geometry.size.width, geometry.size.height))
                    
                    RedBorder(cols: cols, frameHeight: hexagonHeight(geometry.size.width), frameWidth: hexagonWidth(geometry.size.width))
                        .position(x: xPositionTopRedBorder(geometry.size.width), y: yPositionTopRedBorder(geometry.size.height, geometryWidth: geometry.size.width) + hexagonHeight(geometry.size.width)/4)

                    RedBorder(cols: cols, frameHeight: hexagonHeight(geometry.size.width), frameWidth: hexagonWidth(geometry.size.width))
                        .position(x: xPositionTopRedBorder(geometry.size.width) + (hexagonWidth(geometry.size.width) * CGFloat(cols-1))/2, y: yPositionTopRedBorder(geometry.size.height, geometryWidth: geometry.size.width) + (hexagonHeight(geometry.size.width) * CGFloat(cols-1) * 7/8) + CGFloat(hexagonHeight(geometry.size.width) * 3/4))

                    LazyVGrid(columns: gridItems, spacing: 0) {
                        ForEach(items, id: id) { item in
                            VStack() {
                                viewForItems(item)
                                    .frame(width: hexagonWidth(geometry.size.width), height: hexagonHeight(geometry.size.width))
                                    .offset(x: offset(id: items.firstIndex(matching: item)!, geometryWidth: geometry.size.width))
                                    .padding(.top, -hexagonHeight(geometry.size.width)/8)
                            }
                        }
                    }
                    .zIndex(1)
                }
        }
    }
    
    func offset(id: Int, geometryWidth: CGFloat) -> CGFloat {
        CGFloat(id / cols) * hexagonWidth(geometryWidth / 2) - (hexagonWidth(geometryWidth) * CGFloat(cols - 1) / 4)
    }
    
    var hexInOneLine: CGFloat {
        if cols % 2 == 0 {
            return CGFloat(cols) + CGFloat(cols/4) - 0.5
        }
        return CGFloat(cols) + CGFloat(cols/4)
    }
    
    func hexagonWidth(_ geometryWidth: CGFloat) -> CGFloat {
        CGFloat(sin(60 * Double.pi / 180)) * (geometryWidth / hexInOneLine)
    }
    
    func hexagonHeight(_ geometryWidth: CGFloat) -> CGFloat {
        (geometryWidth / hexInOneLine) * 7/8
    }
    
    func yPositionTopRedBorder(_ geometryHeight: CGFloat, geometryWidth: CGFloat) -> CGFloat {
        (geometryHeight - (hexagonHeight(geometryWidth) * CGFloat(cols-2) * 7/8 + hexagonHeight(geometryWidth) + hexagonHeight(geometryWidth))) / 2
    }
    
    func xPositionTopRedBorder(_ geometryWidth: CGFloat) -> CGFloat {
        return (CGFloat(cols) - 0.5) * hexagonWidth(geometryWidth) / 2
    }
    
    func xOffsetRightBlueBorder(_ geometryWidth: CGFloat) -> CGFloat {
        if cols % 2 == 0 {
            return -(CGFloat(cols) * (hexagonWidth(geometryWidth)) / 4 - hexagonWidth(geometryWidth) * 3 / 4) - CGFloat(hexagonWidth(geometryWidth) / 16)
        }
        return -(CGFloat(cols) * (hexagonWidth(geometryWidth)) / 4 - hexagonWidth(geometryWidth) / 4) - CGFloat(hexagonWidth(geometryWidth) / 16)
    }
    
    func xOffsetLeftBlueBorder(_ geometryWidth: CGFloat, _ geometryHeight: CGFloat) -> CGFloat {
        xOffsetRightBlueBorder(geometryWidth) + hexagonWidth(geometryWidth) * CGFloat(cols) - (hexagonWidth(geometryWidth)/2) + CGFloat(hexagonWidth(geometryHeight) / 16)
    }
}

extension HexGrid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], cols: Int, viewForItems: @escaping (Item) -> ItemView) {
        self.init(items, cols: cols, id: \Item.id, viewForItems: viewForItems)
    }
}
