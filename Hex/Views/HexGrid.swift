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

            RedBorder(cols: cols, frameHeight: hexagonHeight(geometry.size.width), frameWidth: hexagonWidth(geometry.size.width))
                .offset(x: cols % 2 == 0 ? (geometry.size.width - (hexInOneLine + 1) * hexagonWidth(geometry.size.width)) + hexagonWidth(geometry.size.width)/4 : geometry.size.width - (hexInOneLine + 1) * hexagonWidth(geometry.size.width))
            RedBorder(cols: cols, frameHeight: hexagonHeight(geometry.size.width), frameWidth: hexagonWidth(geometry.size.width))
                .offset(x: cols % 2 == 0 ? CGFloat(cols / 2) * hexagonWidth(geometry.size.width) + geometry.size.width - (hexInOneLine+1) * hexagonWidth(geometry.size.width) - hexagonWidth(geometry.size.width) / 8 : CGFloat(cols / 2) * hexagonWidth(geometry.size.width) + geometry.size.width - (hexInOneLine+1) * hexagonWidth(geometry.size.width), y: (hexagonHeight(geometry.size.width * 7 / 8)) * CGFloat(cols - 1) - (hexagonHeight(geometry.size.width / 2)))
//            BlueBorder(cols: cols, frameHeight: hexagonHeight(geometry.size.width), frameWidth: hexagonWidth(geometry.size.width)).offset(x: CGFloat(cols / 2) * hexagonWidth(geometry.size.width) + geometry.size.width - (hexInOneLine) * (hexagonWidth(geometry.size.width)))
//            BlueBorder(cols: cols, frameHeight: hexagonHeight(geometry.size.width), frameWidth: hexagonWidth(geometry.size.width)).offset(x: CGFloat(cols) * hexagonHeight(geometry.size.width) - hexagonHeight(geometry.size.width) / 2)

            ScrollView(.vertical) {
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(items, id: id) { item in
                        VStack() {
                            viewForItems(item)
                                .frame(width: hexagonWidth(geometry.size.width), height: hexagonHeight(geometry.size.width))
                                .clipShape(PolygonShape(sides: 6))
                                .offset(x: offset(id: items.firstIndex(matching: item)!, geometryWidth: geometry.size.width))
                                .padding(.bottom, -hexagonHeight(geometry.size.width) / 8)
                                .padding(.top, items.firstIndex(matching: item)! / cols == 0 ? 0 : -hexagonHeight(geometry.size.width) / 8)
                        }
                    }
                }
            }
            .zIndex(1)
            .offset(y: hexagonHeight(geometry.size.width) / 4)
        }
    }
    func offset(id: Int, geometryWidth: CGFloat) -> CGFloat {
        CGFloat(id / cols) * hexagonWidth(geometryWidth / 2) - (hexagonWidth(geometryWidth) * CGFloat(cols - 1) / 4)
        
    }
    var hexInOneLine: CGFloat {
        CGFloat(cols + (cols / 2))
    }
    
    func hexagonWidth(_ geometryWidth: CGFloat) -> CGFloat {
        CGFloat(sin(60 * Double.pi / 180)) * geometryWidth / hexInOneLine
    }
    
    func hexagonHeight(_ geometryWidth: CGFloat) -> CGFloat {
        geometryWidth / hexInOneLine
    }
}

extension HexGrid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], cols: Int, viewForItems: @escaping (Item) -> ItemView) {
        self.init(items, cols: cols, id: \Item.id, viewForItems: viewForItems)
    }
}

struct HexGrid_Preview: PreviewProvider {
    static var cellArray = [Cell]()
    static func appendArray() -> [Cell]{
        for index in (0..<121) {
            cellArray.append(Cell(id: index))
        }
        return cellArray
    }
    static var previews: some View {
        HexGrid(appendArray(), cols: 6) { cell in
            CellView(cell: cell)
        }
    }
}
