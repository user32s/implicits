// Copyright 2024 Yandex LLC. All rights reserved.

public struct OrderedGraph<Element, Edge> {
  public typealias Index = GraphIndex

  private typealias Storage = [Node]

  public struct Node: CustomStringConvertible {
    public var value: Element
    public var successors: [Index: Edge]

    public init(_ value: Element, _ children: [Index: Edge]) {
      self.value = value
      self.successors = children
    }

    public var description: String {
      "\(value) -> \(successors)"
    }
  }

  private var nodes: [Node]

  private init(nodes: [Node]) {
    self.nodes = nodes
  }

  public init() {
    self.init(nodes: [])
  }

  public mutating func addNode(
    _ value: Element,
    parent: Index?,
    edge: Edge
  ) -> Index {
    let node = Node(value, [:])
    nodes.append(node)
    let index = Index(nodes.count - 1)
    if let parent {
      nodes[parent.value].successors[index] = edge
    }
    return index
  }

  public mutating func addEdge(
    from: Index, to: Index, edge: Edge
  ) {
    nodes[from.value].successors[to] = edge
  }

  public func valueWithEdges(at index: Index) -> Node {
    nodes[index.value]
  }

  public func mapValues<T>(
    _ transform: (Element) -> T
  ) -> OrderedGraph<T, Edge> {
    .init(nodes: nodes.map {
      .init(transform($0.value), $0.successors)
    })
  }

  public func mapEdges<T>(
    _ transform: (Edge) -> T
  ) -> OrderedGraph<Element, T> {
    .init(nodes: nodes.map {
      .init($0.value, $0.successors.mapValues(transform))
    })
  }

  public subscript(index: Index) -> Element {
    set {
      nodes[index.value].value = newValue
    }
    _modify {
      yield &nodes[index.value].value
    }
    _read {
      yield nodes[index.value].value
    }
  }
}

extension OrderedGraph where Edge == Void {
  mutating func addNode(_ value: Element, parent: Index?) -> Index {
    addNode(value, parent: parent, edge: ())
  }

  mutating func addEdge(from: Index, to: Index) {
    addEdge(from: from, to: to, edge: ())
  }
}

public struct GraphIndex: Hashable, Comparable, CustomStringConvertible {
  fileprivate var value: Int

  fileprivate init(_ value: Int) {
    self.value = value
  }

  public static func <(lhs: Self, rhs: Self) -> Bool {
    lhs.value < rhs.value
  }

  public var description: String {
    value.description
  }
}
