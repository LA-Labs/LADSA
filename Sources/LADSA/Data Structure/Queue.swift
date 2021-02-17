//
//  Queue.swift
//  
//
//  Created by Amir Lahav on 15/02/2021.
//

import Foundation

public class Queue<T: Hashable> {
    
    private var elements: [T] = []
    
    public func enqueue(_ value: T) {
        elements.append(value)
    }
    
    public func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    public var head: T? {
        return elements.first
    }
    
    public var tail: T? {
        return elements.last
    }
    
    public var count: Int {
        elements.count
    }
}
