//
//  DBSCAN.swift
//  
//
//  Created by Amir Lahav on 14/02/2021.
//

import Foundation

public class DBSCAN {
    
    private class Point<Value: Equatable>: Equatable {
        typealias Label = Int

        let value: Value
        var label: Label?

        init(_ value: Value) {
            self.value = value
        }

        static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.value == rhs.value
        }
    }

    public init() { }

    /**
     Clusters values according to the specified parameters.
     - Parameters:
    - values: values to be clustered
       - epsilon: The maximum distance from a specified value
                  for which other values are considered to be neighbours.
       - minimumNumberOfPoints: The minimum number of points
                                required to form a dense region.
       - distanceFunction: A function that computes
                           the distance between two values.
     - Throws: Rethrows any errors produced by `distanceFunction`.
     - Returns: A tuple containing an array of clustered values
                and an array of outlier values.
    */
    public func cluster<Value: Equatable>(values: [Value], epsilon: Double,
                               minimumNumberOfPoints: Int,
                               distanceFunction: (Value, Value) throws -> Double) rethrows -> [[Value]] {
        precondition(minimumNumberOfPoints >= 0)

        let points = values.map { Point($0) }

        var currentLabel = 0
        for point in points {
            guard point.label == nil else { continue }

            var neighbors = try points.filter { try distanceFunction(point.value, $0.value) < epsilon }
            if neighbors.count >= minimumNumberOfPoints {
                defer { currentLabel += 1 }
                point.label = currentLabel

                while !neighbors.isEmpty {
                    let neighbor = neighbors.removeFirst()
                    guard neighbor.label == nil else { continue }

                    neighbor.label = currentLabel

                    let n1 = try points.filter { try distanceFunction(neighbor.value, $0.value) < epsilon }
                    if n1.count >= minimumNumberOfPoints {
                        neighbors.append(contentsOf: n1)
                    }
                }
            }
        }

        var clusters: [[Value]] = []
        var outliers: [Value] = []

        for points in Dictionary(grouping: points, by: { $0.label }).values {
            let values = points.map { $0.value }
            if values.count == 1 {
                outliers.append(contentsOf: values)
            } else {
                clusters.append(values)
            }
        }

        return (clusters)
    }
}

