//
//  UniqueQueue.swift
//  Fly.ai
//
//  Created by amir.lahav on 21/10/2020.
//

import Foundation

public class UniqueQueue<T: Hashable> {
    
    private var elements: [T] = []
    private var uniqueElemnt: Set<T> = Set<T>()
    
    public func enqueue(_ value: T) {
        if uniqueElemnt.insert(value).inserted {
            elements.append(value)
        }
    }
    
    public func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        let elemnt = elements.removeFirst()
        uniqueElemnt.remove(elemnt)
        return elemnt
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
