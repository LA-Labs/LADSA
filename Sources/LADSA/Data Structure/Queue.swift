//
//  File.swift
//  
//
//  Created by Amir Lahav on 15/02/2021.
//

import Foundation

class Queue<T: Hashable> {
    
    private var elements: [T] = []
    
    func enqueue(_ value: T) {
        elements.append(value)
    }
    
    func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
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
