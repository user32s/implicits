import Implicits

private func entry1() {
  // expected-error@+1 {{Unresolved requirements: \.key1, \.key2, key1}}
  let scope = ImplicitScope()
  defer { scope.end() }

  @Implicit()
  var v1 = Key2()

  f(scope)
}

private func f(_: ImplicitScope) {
  @Implicit(\.key1)
  var v1: Bool

  @Implicit(\.key2)
  var v2: Bool

  @Implicit()
  var v3: key1

  @Implicit()
  var v4: Key2
}

private struct key1 {}
private struct Key2 {
  init() {}
}

extension ImplicitsKeys {
  // expected-key fileprivate key1: Bool
  fileprivate static let key1 = Key<Bool>()
  // expected-key fileprivate key2: Bool
  fileprivate static let key2 = Key<Bool>()
}

extension ImplicitsKeys {
  // expected-error@+1 {{Unexpected declaration inside 'ImplicitsKeys'. Only 'static let keyName = Key<Type>()' are allowed}}
  fileprivate enum Tag {}
  // expected-error@+1 {{Implicit key declaration must be static}}
  fileprivate var key1: ImplicitKey<Bool, Tag>.Type { ImplicitKey<Bool, Tag>.self }
  // expected-error@+1 {{Implicit key declaration must be static}}
  fileprivate var key2: ImplicitKey<Bool, Tag>.Type { ImplicitKey<Bool, Tag>.self }
}
