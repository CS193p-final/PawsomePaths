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
                .frame(width: geometry.size.width / hexInOneLine * CGFloat(cols - 1), height: geometry.size.width / hexInOneLine / 2, alignment: .center)
                //.offset(y: -geometry.size.width / hexInOneLine / 4)
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: diagonalLength(geometry.size.width), height: geometry.size.width / hexInOneLine / 2, alignment: .center)
                .rotationEffect(Angle.degrees(60))
                .offset(x: diagonalLength(geometry.size.width) / 2 + (geometry.size.width / hexInOneLine) / 2
                    ,y: geometry.size.width / hexInOneLine * CGFloat((cols / 2)) + geometry.size.width / hexInOneLine / 2)
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: diagonalLength(geometry.size.width), height: geometry.size.width / hexInOneLine / 2, alignment: .center)
                .rotationEffect(Angle.degrees(60))
                .offset(x: -(geometry.size.width / hexInOneLine * CGFloat(cols + 4)) / 4, y: geometry.size.width / hexInOneLine * CGFloat(cols / 2) + geometry.size.width / hexInOneLine / 2)
            Rectangle()
                .foregroundColor(.red)
                .frame(width: geometry.size.width / hexInOneLine * CGFloat(cols), height: geometry.size.width / 16.5 / 2, alignment: .center)
                .offset(x: geometry.size.width / hexInOneLine * CGFloat((cols + 1) / 2), y: geometry.size.width / hexInOneLine * CGFloat(cols))
            ScrollView(.vertical) {
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(items, id: id) { item in
                        VStack(spacing: 0) {
                            viewForItems(item)
                                .frame(width: geometry.size.width / hexInOneLine, height: geometry.size.width / hexInOneLine)
                                .clipShape(PolygonShape(sides: 6).rotation(Angle.degrees(90)))
                                .offset(x: offset(id: items.firstIndex(matching: item)!, hexagonWidth: hexagonWidth))
                        }
                    }
                }
            }
            .zIndex(1)
            .offset(y: geometry.size.width / hexInOneLine / 4)
        }
    }
    func offset(id: Int, hexagonWidth: CGFloat) -> CGFloat {
        CGFloat(id / cols + 1) * CGFloat(hexagonWidth / 4) - CGFloat(6 * hexagonWidth / 4)
    }
    var hexInOneLine: CGFloat {
        CGFloat(cols + cols / 2)
    }
    func diagonalLength(_ geometryWidth: CGFloat) -> CGFloat {
        (geometryWidth / hexInOneLine * CGFloat(cols)) / CGFloat(sin(60 * Double.pi / 180))
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
