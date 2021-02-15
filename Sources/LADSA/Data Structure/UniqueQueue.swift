//
//  Queue.swift
//  Fly.ai
//
//  Created by amir.lahav on 21/10/2020.
//

import Foundation

class UniqueQueue<T: Hashable> {
    
    private var elements: [T] = []
    private var uniqueElemnt: Set<T> = Set<T>()
    
    func enqueue(_ value: T) {
        if uniqueElemnt.insert(value).inserted {
            elements.append(value)
        }
    }
    
    func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        let elemnt = elements.removeFirst()
        uniqueElemnt.remove(elemnt)
        return elemnt
    }
    
    var head: T? {
        return elements.first
    }
    
    var tail: T? {
        return elements.last
    }
    
    var count: Int {
        elements.count
    }
}
