// Copyright 2022 Yandex LLC. All rights reserved.

/// Protocol for types that can be used as keys for implicits.
///
/// There is only one conforming type – `ImplicitKey` that covers all known usecases.
/// This protocol exists only for convenient generic constraints.
/// ```
/// // Without protocol:
/// f<Tag, Value>(key: ImplicitKey<Tag, Value>)
/// // With protocol:
/// f<Key: ImplicitKeyType>(key: Key)
/// ```
/// As there is a lot of api that works with keys, it is useful to have a protocol.
///
/// - Note: The key is type by itself, not an instance of the type.
///   This means that the key is not associated with any particular value.
public protocol ImplicitKeyType {
  associatedtype Value

  #if DEBUG
  static var customKeyDescription: String? { get }
  #endif
}

#if DEBUG
extension ImplicitKeyType {
  static var customKeyDescription: String? { nil }
}
#endif

/// Concrete implementation of `ImplicitKeyType`. Uninhabited.
///
/// Key is identified by it's value and tag generic arguments.
public enum ImplicitKey<Value, Tag>: ImplicitKeyType {
  public static var customKeyDescription: String? {
    _typeName(Tag.self)
  }
}

/// Namespace for keys declaration.
/// - Example of usage:
/// ```
/// extension ImplicitsKeys {
///   static let network = Key<ResourceStaticParameters>()
/// }
/// ```
///
public enum ImplicitsKeys {
  public struct Key<Value>: Sendable {
    @inlinable public init() {}
  }
}

/// Accessor for a key. Used only for type inference, as `ImplicitsKeys` is uninhabited.
public typealias KeySpecifier<Key: ImplicitKeyType> =
  (ImplicitsKeys) -> Key.Type

#if DEBUG
/// An identifier for an implicit key type.
public struct ImplicitKeyIdentifier: Hashable, CustomDebugStringConvertible {
  @usableFromInline
  internal var type: any ImplicitKeyType.Type

  @inlinable
  internal init(_ type: any ImplicitKeyType.Type) {
    self.type = type
  }

  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(type))
  }

  @inlinable
  public static func ==(lhs: ImplicitKeyIdentifier, rhs: ImplicitKeyIdentifier) -> Bool {
    ObjectIdentifier(lhs.type) == ObjectIdentifier(rhs.type)
  }

  public var debugDescription: String {
    type.customKeyDescription ?? _typeName(type)
  }
}
#else
public typealias ImplicitKeyIdentifier = ObjectIdentifier
#endif

extension ImplicitKeyType {
  /// Concrete value for the key.
  @inlinable
  internal static var id: ImplicitKeyIdentifier {
    ImplicitKeyIdentifier(Self.self)
  }
}

/// A version of `ImplicitKey` without tag.
/// Can be used if there is no need to pass some type with different keys,
/// for example if the type is very domain specific and exists as single instance.
public typealias TypeImplicitKey<Value> = ImplicitKey<Value, Value>
