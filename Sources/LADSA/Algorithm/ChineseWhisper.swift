//
//  ChineseWhisper.swift
//  
//
//  Created by Amir Lahav on 15/02/2021.
//

import Foundation

public struct SamplePair<T: Numeric & Comparable & BinaryFloatingPoint> {
    
    let index1: T
    let index2: T
    let distance: T
    
    init(idx1: T, idx2: T, distance: T = 1) {
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

public struct OrderedSamplePair<T: Numeric & Comparable & BinaryFloatingPoint> {
    let index1: T
    let index2: T
    let distance: T
    
    init(idx1: T, idx2: T, distance: T = 1) {
        self.distance = distance
        index1 = idx1
        index2 = idx2
    }
}

public struct Pair<T: Numeric & Comparable & BinaryFloatingPoint> {
    let index1: T
    let index2: T
    
    init(idx1: T, idx2: T) {
        index1 = idx1
        index2 = idx2
    }
}

public class ChineseWhispers {
    
    public static func chinese_whispers<T>(
        objects: [T],
        distanceFunction: (T, T) -> Double,
        eps: Double,
        numIterations: Int) -> [Int] {
        var edges: [SamplePair<Double>] = []
        guard !objects.isEmpty else {
            return []
        }
        for i in 0...objects.count-1 {
            for j in i...objects.count-1 {
                let length = distanceFunction(objects[i], objects[j])
                if length < eps {
                    edges.append(SamplePair(idx1: Double(i), idx2: Double(j)))
                }
            }
        }
        return chinese_whispers(edges: edges, numIterations: numIterations)
    }
    
    public static func chinese_whispers<T: Numeric & Comparable & BinaryFloatingPoint>(
        edges: [SamplePair<T>],
        numIterations: Int) -> [Int] {
        let orderdEdges = EdgeListGraph.convertUnorderedToOrdered(edges: edges)
        return chinese_whispers(edges: orderdEdges, numIterations: numIterations)
    }
    
    public static func chinese_whispers<T: Numeric & Comparable & BinaryFloatingPoint>(
        edges: [OrderedSamplePair<T>],
        numIterations: Int) -> [Int] {
        let neighbors = EdgeListGraph.findNeighborRanges(edges: edges)
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
    
    public static func group<T>(objects: [T], labels: [Int]) -> [[T]] {
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
