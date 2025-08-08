import Implicits

private func entry() {
  let scope = ImplicitScope() // expected-error {{Unresolved requirements: Int, UInt, UInt16}}
  defer { scope.end() }

  if Bool.random() {
    f1(scope)
  } else {
    f2(scope)
  }
  if Bool.random() {
    let scope = scope.nested()
    defer { scope.end() }
    @Implicit()
    var i: UInt8 = 0
    @Implicit()
    var j: UInt16 = 0
    f3(scope)
  } else {
    f4(scope)
  }
}

private func f1(_: ImplicitScope) {
  @Implicit()
  var i: Int
}

private func f2(_: ImplicitScope) {
  @Implicit()
  var i: UInt
}

private func f3(_: ImplicitScope) {
  @Implicit()
  var i: UInt8
  @Implicit()
  var j: UInt16
}

private func f4(_: ImplicitScope) {
  @Implicit()
  var i: UInt16
}
