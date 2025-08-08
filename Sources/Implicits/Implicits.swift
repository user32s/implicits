// Copyright 2022 Yandex LLC. All rights reserved.

/// Collection of type erased implicit values.
public struct Implicits {
  /// Captured implicit arguments
  @usableFromInline
  internal var args: Arguments

  fileprivate init(args: Arguments) {
    self.args = args
  }
}

extension Implicits {
  /// Creates context with captured arguments specified by raw keys
  /// from the current context.
  @_spi(Unsafe)
  public init(unsafeKeys keys: ImplicitKeyIdentifier...) {
    let captured = measure(.implicitsWithUnsafeKeys) {
      let ctx = RawStore.current().getContext()
      return keys.reduce(into: Arguments()) { captured, key in
        captured[key] = ctx[key]
      }
    }
    self.init(args: captured)
  }

  /// Get raw key for a given key specifier.
  /// Used only in codegeneration.
  /// - Parameter key: key specifier
  /// - Returns: raw key
  @inlinable
  @_spi(Unsafe)
  public static func getRawKey<Key: ImplicitKeyType>(
    _: KeySpecifier<Key>
  ) -> ImplicitKeyIdentifier {
    Key.id
  }

  /// Get raw key of a type key for a given type
  /// Used only in codegeneration.
  /// - Parameter type: type of type key
  /// - Returns: raw key
  @inlinable
  @_spi(Unsafe)
  public static func getRawKey<Value>(
    _: Value.Type
  ) -> ImplicitKeyIdentifier {
    TypeImplicitKey<Value>.id
  }
}
