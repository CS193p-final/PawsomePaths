//
//  Queue.swift
//  Hex
//
//  Created by Duong Pham on 2/15/21.
//

import Foundation

struct Queue<Element> {
    private var array = [Element]()
    
    public var count: Int { array.count }
    
    public var isEmpty: Bool { array.isEmpty }
    
    public mutating func enqueue(_ newElement: Element) {
        array.append(newElement)
    }
    
    public mutating func dequeue() -> Element? {
        if isEmpty {
            return nil
        }
        return array.removeFirst()
    }
    
    public var front: Element? {
        array.first
    }
}
