import Implicits

private func entry() {
  let scope = ImplicitScope()
  defer { scope.end() }

  @Implicit
  var i1 = S1()

  // expected-error@+2 {{Unresolved symbol 'S2()'}}
  @Implicit
  var i2 = S2()

  @Implicit
  var i3 = C1()

  @Implicit
  var i4 = C2()

  requires(scope)
}

private func requires(_: ImplicitScope) {
  @Implicit() var i1: S1
  @Implicit() var i2: C1
  @Implicit() var i3: C2
}

private struct S1 {
  var i: Int = 0
  var j: Int = 1 { didSet { print(oldValue) } }
  var k: Int { i + j }
}

private struct S2 {
  // expected-note@+1 {{While resolving S2(). Unable to synthesize initializer with tuple member variable}}
  var (j, k) = (0, 1)
}

// weak and optional vars
private class C1 {
  weak var i: C1!
  weak var j: C1?
  var k: C1?
}

// default values
private final class C2 {
  var i = 0
  var j = "j"
  var k = UnsafePointer<Int>(bitPattern: 0)
}
