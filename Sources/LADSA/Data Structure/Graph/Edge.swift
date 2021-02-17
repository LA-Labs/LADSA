//
//  Edge.swift
//  
//
//  Created by Amir Lahav on 15/02/2021.
//

import Foundation

public struct Edge<T>: Equatable where T: Hashable {

  public let from: Vertex<T>
  public let to: Vertex<T>

  public let weight: Double?

}

extension Edge: CustomStringConvertible {

  public var description: String {
    guard let unwrappedWeight = weight else {
      return "\(from.description) -> \(to.description)"
    }
    return "\(from.description) -(\(unwrappedWeight))-> \(to.description)"
  }

}

extension Edge: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(from)
    hasher.combine(to)
    if weight != nil {
      hasher.combine(weight)
    }
  }

}

public func == <T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
  guard lhs.from == rhs.from else {
    return false
  }

  guard lhs.to == rhs.to else {
    return false
  }

  guard lhs.weight == rhs.weight else {
    return false
  }

  return true
}
