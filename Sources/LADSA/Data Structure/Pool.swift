//
//  File.swift
//  
//
//  Created by Amir Lahav on 15/02/2021.
//

import Foundation

class Pool<T> {
    private let accessQueue = DispatchQueue(label: "com.shuttefly.synchronizedArray", attributes: .concurrent)

    
    // the pool of objects is a queue
    // thread safe.
    // must be called from main queue.
    private var objectPool = [T]()
    
    init(items:[T]) {
        objectPool.reserveCapacity(objectPool.count)
        for item in items {
            objectPool.append(item)
        }
    }
    
    func acquire() -> T? {
        // return the first object in the array
        // FIFO
        self.accessQueue.sync(flags: .barrier) {
            return objectPool.count > 0 ? self.objectPool.remove(at: 0) : nil
        }
    }
    
    func release(_ item: T) {
        self.accessQueue.sync(flags: .barrier) {
            self.objectPool.append(item)
        }
    }
}
