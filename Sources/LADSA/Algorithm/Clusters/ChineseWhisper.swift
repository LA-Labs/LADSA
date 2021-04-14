//
//  ChineseWhisper.swift
//  
//
//  Created by Amir Lahav on 15/02/2021.
//

import Foundation

struct SamplePair<T: Comparable> {
    
    let index1: T
    let index2: T
    let distance: Double
    
    init(idx1: T, idx2: T, distance: Double = 1) {
        self.distance = distance
        if (idx1 < idx2) {
            index1 = idx1
            index2 = idx2
        } else {
            index1 = idx2
            index2 = idx1
        }
    }
}

struct OrderedSamplePair<T> {
    
    let index1: T
    let index2: T
    let distance: Double
    
    init(idx1: T, idx2: T, distance: Double = 1) {
        self.distance = distance
        index1 = idx1
        index2 = idx2
    }
}

struct Pair<T> {
    let index1: Int
    let index2: Int
    
    init(idx1: Int, idx2: Int) {
        index1 = idx1
        index2 = idx2
    }
}


public class ChineseWhisper {
    
    public init() {}
    
    public func cluster<T>(
        objects: [T],
        distanceFunction: (T, T) -> Double,
        eps: Double,
        numIterations: Int) -> [Int] {
        var edges: [SamplePair<Int>] = []
        guard !objects.isEmpty else {
            return []
        }
        for i in 0...objects.count-1 {
            for j in i...objects.count-1 {
                let length = distanceFunction(objects[i], objects[j])
                if length < eps {
                    edges.append(SamplePair(idx1: i, idx2: j))
                }
            }
        }
        return cluster(edges: edges, numIterations: numIterations)
    }
    
    func cluster(
        edges: [SamplePair<Int>],
        numIterations: Int) -> [Int] {
        let orderedEdges = convertUnorderedToOrdered(edges: edges)
        return cluster(edges: orderedEdges, numIterations: numIterations)
    }
    
    func cluster(
        edges: [OrderedSamplePair<Int>],
        numIterations: Int) -> [Int] {
        let neighbors = findNeighborRanges(edges: edges)
        var labels: [Int] = Array<Int>(repeating: 0, count: neighbors.count)
        for i in 0...neighbors.count-1 {
            labels[i] = i
        }
        
        for _ in 0..<(neighbors.count * numIterations) {
            
            // Pick a random node.
            let idx = Int.random(in: 0..<neighbors.count)
            var labels_to_counts: [Int: Double] = [:]
            let end: Int = Int(neighbors[idx].index2)
            
            for i in Int(neighbors[idx].index1)..<end {
                
                labels_to_counts[labels[Int(edges[i].index2)], default: 0] += Double(edges[i].distance)
            }
            
            var bestScore: Double = -Double.infinity
            var bestLabel = labels[idx]
            let sorted_labels_to_counts = labels_to_counts.sorted { (a, b) -> Bool in
                a.key < b.key
            }
            sorted_labels_to_counts.forEach { (i) in
                if i.value > bestScore {
                    bestScore = i.value
                    bestLabel = i.key
                }
            }
            labels[idx] = bestLabel
        }
        var label_remap: [Int: Int] = [:]
        for (i, _) in labels.enumerated() {
            let next_id = label_remap.count
            if label_remap[labels[i]] == nil {
                label_remap[labels[i]] = next_id
            }
        }
        
        for (i, _) in labels.enumerated() {
            labels[i] = label_remap[labels[i]] ?? 0
        }
        return labels
    }
    
    func group<T>(objects: [T], labels: [Int]) -> [[T]] {
        precondition(objects.count == labels.count)
        var cluster: [Int : [T]] = [:]
        for (i, value) in labels.enumerated() {
            if cluster[value] != nil {
                cluster[value]!.append(objects[i])
            }else {
                cluster[value] = [objects[i]]
            }
        }
        return cluster.map { (_ , value) -> [T] in
           value
        }
    }
}

private extension ChineseWhisper {
    
    func convertUnorderedToOrdered(edges: [SamplePair<Int>]) -> [OrderedSamplePair<Int>] {
        var orderedPairs: [OrderedSamplePair<Int>] = []
        orderedPairs.reserveCapacity(edges.count*2)
        
        for (i, _) in edges.enumerated() {
            orderedPairs.append(OrderedSamplePair(idx1: edges[i].index1, idx2: edges[i].index2, distance: edges[i].distance))
            if edges[i].index1 != edges[i].index2 {
                orderedPairs.append(OrderedSamplePair(idx1: edges[i].index2, idx2: edges[i].index1, distance: edges[i].distance))
            }
        }
        return orderedPairs.sorted { (a, b) -> Bool in
            a.index1 < b.index1 || (a.index1 == b.index1 && a.index2 < b.index2)
        }
    }
    
    func findNeighborRanges(edges: [OrderedSamplePair<Int>]) -> [Pair<Int>] {
        let numNodes: Int = maxIndexPlusOne(pairs: edges)
        var neighbours: [Pair<Int>] = Array(repeating: Pair(idx1: 0, idx2: 0), count: Int(numNodes))
        var cur_node: Int = 0
        var start_idx: Int = 0
        
        for (index, value) in edges.enumerated() {
            if value.index1 != cur_node {
                neighbours[Int(cur_node)] = Pair(idx1: start_idx,
                                                idx2: index)
                start_idx = index
                cur_node = value.index1
            }
        }
        if !neighbours.isEmpty {
            neighbours[Int(cur_node)] = Pair(idx1: start_idx,
                                            idx2: edges.count)
        }
        return neighbours
    }
    
    func maxIndexPlusOne(pairs: [OrderedSamplePair<Int>]) -> Int {
        if pairs.count == 0 {
            return 0
        }else {
            var max_idx: Int = 0
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
