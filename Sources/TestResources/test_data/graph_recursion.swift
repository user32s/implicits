import Implicits

private func entry() {
  let scope = ImplicitScope() // expected-error {{Unresolved requirement: Int}}
  defer { scope.end() }

  recurse(scope)
}

private func recurse(_ scope: ImplicitScope) {
  @Implicit()
  var i: Int

  if Bool.random() {
    let scope = scope.nested()
    defer { scope.end() }

    @Implicit
    var i: Int = 5
    recurse(scope)
  }
}

private func entry2() {
  let scope = ImplicitScope() // expected-error {{Unresolved requirement: UInt}}
  defer { scope.end() }

  recurse2(scope)
}

private func recurse2(_ scope: ImplicitScope) {
  if Bool.random() {
    let scope = scope.nested()
    defer { scope.end() }

    @Implicit
    var i: Int = 5

    recurse2a(scope)
  }
}

private func recurse2a(_ scope: ImplicitScope) {
  @Implicit()
  var i: Int

  if Bool.random() {
    recurse2(scope)

    @Implicit()
    var j: UInt
  }
}
