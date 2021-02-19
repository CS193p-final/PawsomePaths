//
//  HexGrid.swift
//  Hex
//
//  Created by Duong Pham on 2/14/21.
//

import SwiftUI

struct HexGrid<Item, ID, ItemView>: View where Item: Identifiable, ID: Hashable, ItemView: View{
    private var items: [Item]
    private var id: KeyPath<Item,ID>
    private var viewForItems: (Item) -> ItemView
    private let cols: Int = 11
        
    init(_ items: [Item], id: KeyPath<Item, ID>, viewForItems: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItems = viewForItems
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItems = Array(repeating: GridItem(.fixed(geometry.size.width/hexInOneLine), spacing: 0), count: cols)

            RedBorder(cols: cols, frameSize: geometry.size.width / hexInOneLine)
            RedBorder(cols: cols, frameSize: geometry.size.width / hexInOneLine)
                .offset(x: CGFloat(cols / 2) * geometry.size.width / CGFloat(hexInOneLine), y: geometry.size.width / hexInOneLine * CGFloat(cols) - geometry.size.width / hexInOneLine / 2)
            BlueBorder(cols: cols, frameSize: geometry.size.width / hexInOneLine, geometryWidth: geometry.size.width)
            BlueBorder(cols: cols, frameSize: geometry.size.width / hexInOneLine, geometryWidth: geometry.size.width)
                .offset(x: CGFloat(cols) * geometry.size.width / CGFloat(hexInOneLine) - geometry.size.width / hexInOneLine / 2)

            ScrollView(.vertical) {
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(items, id: id) { item in
                        VStack(spacing: 0) {
                            viewForItems(item)
                                .clipShape(PolygonShape(sides: 6))
                                .frame(width: geometry.size.width / hexInOneLine, height: geometry.size.width / hexInOneLine)
                                .offset(x: offset(id: items.firstIndex(matching: item)!, geometryWidth: geometry.size.width))
                        }
                    }
                }
            }
            .zIndex(1)
            .offset(y: geometry.size.width / hexInOneLine / 4)
        }
    }
    func offset(id: Int, geometryWidth: CGFloat) -> CGFloat {
        CGFloat(id / cols) * (geometryWidth / CGFloat(hexInOneLine * 2))
            - ((geometryWidth - (geometryWidth / hexInOneLine) * CGFloat(cols)) / 2)
    }
    var hexInOneLine: CGFloat {
        CGFloat(cols + cols / 2)
    }
}

extension HexGrid where Item: Identifiable, ID == Item.ID {
    init(_ items: [Item], viewForItems: @escaping (Item) -> ItemView) {
        self.init(items, id: \Item.id, viewForItems: viewForItems)
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
        HexGrid(appendArray()) { cell in
            CellView(cell: cell)
        }
    }
}
