//
//  Deque.swift
//  Hex
//
//  Created by Duong Pham on 3/5/21.
//

import Foundation

struct Deque<Element> {
    private var array = [Element]()
    
    public var count: Int { array.count }
    
    public var isEmpty: Bool { array.isEmpty }
    
    public var front: Element? { array.first }
    
    public var back: Element? { array.last }
    
    public mutating func pushFront(_ newElement: Element) {
        array.insert(newElement, at: 0)
    }
    
    public mutating func pushBack(_ newElement: Element) {
        array.append(newElement)
    }
    
    public mutating func popFront() -> Element? {
        if isEmpty {
            return nil
        }
        return array.removeFirst()
    }
    
    public mutating func popBack() -> Element? {
        if isEmpty {
            return nil
        }
        return array.removeLast()
    }
}

