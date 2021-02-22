//
//  EdgeListGraph.swift
//  
//
//  Created by Amir Lahav on 15/02/2021.
//

import Foundation

public class EdgeListGraph {
    
    public static func convertUnorderedToOrdered<T: Numeric & Comparable>(edges: [SamplePair<T>]) -> [OrderedSamplePair<T>] {
        var orderdPairs: [OrderedSamplePair<T>] = []
        orderdPairs.reserveCapacity(edges.count*2)
        
        for (i, _) in edges.enumerated() {
            orderdPairs.append(OrderedSamplePair(idx1: edges[i].index1, idx2: edges[i].index2, distance: edges[i].distance))
            if edges[i].index1 != edges[i].index2 {
                orderdPairs.append(OrderedSamplePair(idx1: edges[i].index2, idx2: edges[i].index1, distance: edges[i].distance))
            }
        }
        return orderdPairs.sorted { (a, b) -> Bool in
            a.index1 < b.index1 || (a.index1 == b.index1 && a.index2 < b.index2)
        }
    }
    
    public static func findNeighborRanges<T: Numeric & Comparable & BinaryFloatingPoint>(edges: [OrderedSamplePair<T>]) -> [Pair<T>] {
        let numNodes: T = maxIndexPlusOne(pairs: edges)
        var neighbors: [Pair<T>] = Array(repeating: Pair(idx1: 0, idx2: 0), count: Int(numNodes))
        var cur_node: T = 0
        var start_idx: T = 0
        
        for (index, value) in edges.enumerated() {
            if floor(value.index1) != floor(cur_node) {
                neighbors[Int(cur_node)] = Pair(idx1: start_idx, idx2: floor(T(index)))
                start_idx = floor(T(index))
                cur_node = floor(value.index1)
            }
        }
        if !neighbors.isEmpty {
            neighbors[Int(cur_node)] = Pair(idx1: start_idx, idx2: T(edges.count))
        }
        return neighbors
    }
    
    public static func maxIndexPlusOne<T: Numeric & Comparable & BinaryFloatingPoint>(pairs: [OrderedSamplePair<T>]) -> T {
        if pairs.count == 0 {
            return 0
        }else {
            var max_idx: T = 0
            for (_, value) in pairs.enumerated() {
                if value.index1 > max_idx {
                    max_idx = value.index1
                }
                if value.index2 > max_idx {
                    max_idx = value.index2
                }
            }
            return max_idx + 1
        }
        
    }
}
