// Copyright 2024 Yandex LLC. All rights reserved.

public struct ImplicitKey: Hashable, Sendable {
  public enum Kind: Sendable {
    case type
    case keyPath
  }

  public var kind: Kind
  public var name: String

  public var descriptionForDiagnostics: String {
    switch kind {
    case .type: "\(name)"
    case .keyPath: "\\.\(name)"
    }
  }

  public var lexicographicalOrder: String {
    switch kind {
    case .type: "0\(name)"
    case .keyPath: "1\(name)"
    }
  }

  public init(kind: Kind, name: String) {
    self.kind = kind
    self.name = name
  }

  public static func type(_ name: String) -> Self {
    Self(kind: .type, name: name)
  }

  public static func keyPath(_ name: String) -> Self {
    Self(kind: .keyPath, name: name)
  }
}
