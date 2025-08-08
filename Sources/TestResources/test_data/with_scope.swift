import Implicits

private func entry() throws {
  withScope { scope in // expected-error {{Unresolved requirement: UInt8}}
    requireUInt8(scope)
  }

  try withScope { scope in // expected-error {{Unresolved requirement: UInt8}}
    requireUInt8(scope)

    throw Err()
  }

  withScope { scope in // expected-error {{Unresolved requirement: UInt8}}
    if Bool.random() {
      let scope = scope.nested()
      defer { scope.end() }

      @Implicit()
      var _: UInt16 = 0

      requireUInt8(scope)
      requireUInt16(scope)
    }
  }
}

private func requireUInt8(_ scope: ImplicitScope) {
  @Implicit()
  var foo: UInt8
}

private func requireUInt16(_ scope: ImplicitScope) {
  @Implicit()
  var _: UInt16
}

private struct Err: Error {}
