@testable import AnotherModule

import Implicits

private func entry() {
  // expected-error@+1 {{Unresolved requirement: UInt8}}
  let scope = ImplicitScope()
  defer { scope.end() }

  @Implicit
  var v1 = AnotherModuleInternalStruct(scope)
}
