import Implicits

struct AnotherModuleStruct {}

public struct AnotherModulePublicStruct {
  var j: Int = 2

  public init() {}
}

#if canImport(Foundation)

import Foundation

#else

public class NSObject {
  public init() {}
}

#endif

public class AnotherModuleNSObject: NSObject {
  var j: Int = 2
}

public func anotherModuleFunction(_: ImplicitScope) {
  @Implicit()
  var v1: AnotherModuleStruct

  @Implicit()
  var v2: AnotherModulePublicStruct

  @Implicit()
  var v3: AnotherModuleNSObject
}

internal struct AnotherModuleInternalStruct {
  internal init(_: ImplicitScope) {
    @Implicit()
    var v1: UInt8
  }
}

extension ImplicitsKeys {
  // expected-key public keyFromAnotherModule: [String: [Int]]
  public static let keyFromAnotherModule = Key<[String: [Int]]>()


  // expected-error@+1 {{Unexpected declaration inside 'ImplicitsKeys'. Only 'static let keyName = Key<Type>()' are allowed}}
  public enum _KeyFromAnotherModuleTag {
  }
  // expected-error@+1 {{Implicit key declaration must be static}}
  @inlinable public var keyFromAnotherModule: ImplicitKey<[String:[Int]], _KeyFromAnotherModuleTag>.Type {
    ImplicitKey<[String:[Int]], _KeyFromAnotherModuleTag>.self
  }
}

