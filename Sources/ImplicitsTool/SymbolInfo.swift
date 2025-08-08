// Copyright 2024 Yandex LLC. All rights reserved.

public struct SymbolInfo<Syntax> {
  public typealias Kind = FunctionKind
  public typealias Namespace = SymbolNamespace

  public struct Parameter: Hashable, Sendable {
    public var name: String
    public var type: String
    public var hasDefaultValue: Bool

    public init(
      name: String, type: String, hasDefaultValue: Bool = false
    ) {
      self.name = name
      self.type = type
      self.hasDefaultValue = hasDefaultValue
    }
  }

  public var kind: Kind
  public var parameters: [Parameter]
  public var namespace: Namespace
  public var returnType: TypeInfo?
  public var syntax: Syntax
  public var file: String

  var callableSignature: CallableSignature {
    CallableSignature(
      kind: kind, namespace: namespace,
      params: parameters.map(\.name), paramTypes: parameters.map(\.type),
      returnType: returnType,
      file: file
    )
  }

  func namespaced(_ name: String) -> Self {
    var copy = self
    copy.namespace.value.insert(name, at: 0) // TODO: Bad
    return copy
  }

  func namespaced(_ namespace: [String]) -> Self {
    var copy = self
    copy.namespace.value.insert(contentsOf: namespace, at: 0) // TODO: Bad
    return copy
  }

  public init(
    kind: Kind, parameters: [Parameter], namespace: Namespace,
    returnType: TypeInfo?,
    syntax: Syntax,
    file: String
  ) {
    self.kind = kind
    self.parameters = parameters
    self.namespace = namespace
    self.returnType = returnType
    self.syntax = syntax
    self.file = file
  }

  init(
    kind: Kind, parameters: [Parameter],
    namespace: [String] = [],
    returnType: TypeInfo?,
    syntax: Syntax, file: String
  ) {
    self.init(
      kind: kind, parameters: parameters, namespace: Namespace(namespace),
      returnType: returnType,
      syntax: syntax, file: file
    )
  }

  static func initializer(
    params: [Parameter], namespace: [String] = [],
    optional: Bool,
    syntax: Syntax,
    file: String
  ) -> Self {
    .init(
      kind: .initializer(optional: optional),
      parameters: params,
      namespace: namespace,
      returnType: nil,
      syntax: syntax,
      file: file
    )
  }

  func mapSyntax<T>(_ transform: (Syntax) -> T) -> SymbolInfo<T> {
    SymbolInfo<T>(
      kind: kind, parameters: parameters.map { param in
        .init(
          name: param.name, type: param.type,
          hasDefaultValue: param.hasDefaultValue
        )
      },
      namespace: namespace,
      returnType: returnType,
      syntax: transform(syntax), file: file
    )
  }
}

extension SymbolInfo: Hashable where Syntax: Hashable {}

/// Typealias for `SymbolInfo` to avoid error 'Type alias 'SymbolInfo' references itself'
typealias SymbolInfoGeneric<Syntax> = SymbolInfo<Syntax>

extension SymbolInfo: Equatable where Syntax: Equatable {}

extension SymbolInfo: Sendable where Syntax: Sendable {}
