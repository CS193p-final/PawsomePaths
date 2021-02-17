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
    private let spacing: CGFloat = 1
        
    init(_ items: [Item], id: KeyPath<Item, ID>, viewForItems: @escaping (Item) -> ItemView) {
        self.items = items
        self.id = id
        self.viewForItems = viewForItems
    }
    
    var body: some View {
        GeometryReader { geometry in
            let hexagonWidth = (geometry.size.width / 12) * cos(.pi / 6) * 2
            let gridItems = Array(repeating: GridItem(.fixed(hexagonWidth), spacing: -hexagonWidth/1.7), count: cols)
            Rectangle()
                .foregroundColor(.red)
                .frame(width: geometry.size.width / 16.5 * 11, height: geometry.size.width / 16.5 / 2, alignment: .center)
            ScrollView(.vertical) {
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(items, id: id) { item in
                        VStack(spacing: 0) {
                            viewForItems(item)
                                .frame(width: geometry.size.width / 16.5, height: geometry.size.width / 16.5)
                                .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
                                .offset(x: offset(id: items.firstIndex(matching: item)!, hexagonWidth: hexagonWidth))
                        }
                    }
                }
            }
            .zIndex(1)
            .offset(y: geometry.size.width / 16.5 / 4)
            Rectangle()
                .foregroundColor(.red)
                .frame(width: geometry.size.width / 16.5 * 11, height: geometry.size.width / 16.5 / 2, alignment: .center)
                .offset(x: geometry.size.width / 16.5 * 5.5, y: geometry.size.width / 16.5 * 11)
        }
    }
    func offset(id: Int, hexagonWidth: CGFloat) -> CGFloat {
        CGFloat(id / 11 + 1) * CGFloat(hexagonWidth / 4) - CGFloat(6 * hexagonWidth / 4)
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
