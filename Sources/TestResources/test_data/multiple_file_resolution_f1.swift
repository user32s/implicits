import Implicits

private func entry1() {
  // expected-error@+1 {{Unresolved requirements: File1, Int8, Internal}}
  let scope = ImplicitScope()
  defer { scope.end() }

  requiresInt8(scope)
  privateFunc(scope)
  internalPrivateFunc(a: absurdConstructor(), scope)
}

private func entry2() {
  // expected-error@+1 {{Unresolved requirement: IntPublic}}
  let scope = ImplicitScope()
  defer { scope.end() }

  Int.publicPrivateFunc(a: absurdConstructor(), scope)
}

struct File1 {}
struct File2 {}

private func privateFunc(_: ImplicitScope) {
  @Implicit()
  var i: File1
}
