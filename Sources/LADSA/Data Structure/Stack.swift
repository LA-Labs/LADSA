//
//  Stack.swift
//  
//
//  Created by amir.lahav on 22/09/2020.
//

import Foundation

public struct Stack<Element> {
    
    private var array: [Element] = []
    
    public init () {}
    public mutating func push(_ element: Element) {
        array.append(element)
    }
    
    public mutating func pop() -> Element? {
        return array.popLast()
    }
    
    public func peek() -> Element? {
        return array.last
    }
    
    public func isEmpty() -> Bool {
        return array.isEmpty
    }
}
