import Implicits

private func entry() {
  let scope = ImplicitScope() // expected-error {{Unresolved requirements: UInt16, UInt8}}
  defer { scope.end() }

  f(scope) // expected-error {{Ambiguous use of 'f(_:)'}}

  functionWithArgs(
    arg1: 1, arg2: 2, 3.0, "4", scope
  )
  functionWithDefaultArgs(arg1: 0, arg4: "4", scope)
  closure(0, scope) // expected-error {{Unresolved symbol 'closure(_:_:)'}}
}

// expected-note@+1 {{Found this candidate}}
private func f(_: ImplicitScope) {
  @Implicit()
  var i: Int
}

#if NO_COMPILE
// expected-note@+1 {{Found this candidate}}
private func f(_: ImplicitScope) {
  @Implicit
  var j: UInt
}
#endif

private func functionWithArgs(
  arg1: Int,
  arg2 _: UInt,
  _ arg3: Double,
  _: String,
  _: ImplicitScope
) {
  _ = (arg1, arg3)
  @Implicit()
  var i: UInt8
}

private func functionWithDefaultArgs(
  arg1: Int = 0,
  arg2: UInt = 1,
  arg3: Double = 2,
  arg4: String = "3",
  _: ImplicitScope
) {
  _ = (arg1, arg2, arg3, arg4)
  @Implicit()
  var i: UInt16
}

nonisolated(unsafe)
private let closure: (Int, ImplicitScope) -> Void = { int, scope in
  @Implicit()
  var i: UInt32
}

// MARK: - Initializers

private func testInitializers() {
  // expected-error@+1 {{Unresolved requirements: UInt16, UInt32, UInt64}}
  let scope = ImplicitScope()
  defer { scope.end() }

  _ = Foo(0, scope)
}


private struct Foo {
  init(_: ImplicitScope) {
    @Implicit()
    var i: UInt64
  }

  init(_: Int, _ scope: ImplicitScope) {
    @Implicit()
    var i: UInt32

    self.init(scope)

    ff(scope)
    self.g(scope)
  }

  func ff(_: ImplicitScope) {
    @Implicit()
    var i: UInt16
  }

  func g(_: ImplicitScope) {
    @Implicit()
    var i: UInt16
  }

  func entry1() {
    // expected-error@+1 {{Unresolved requirements: UInt16, UInt8}}
    let scope = ImplicitScope()
    defer { scope.end() }

    let bar = makeBar(scope)

    bar.bar(scope)
  }

  func makeBar(_: ImplicitScope) -> Bar {
    @Implicit() var uint8: UInt8
    return Bar()
  }

  func entry2() {
    // expected-error@+1 {{Unresolved requirements: UInt16, UInt8}}
    let scope = ImplicitScope()
    defer { scope.end() }

    privateFunc(scope)
    fileprivateFunc(scope)
  }

  private func privateFunc(_: ImplicitScope) {
    @Implicit()
    var v: UInt8
  }

  fileprivate func fileprivateFunc(_: ImplicitScope) {
    @Implicit()
    var v: UInt16
  }

  func entry_nestedCheck() {
    // expected-error@+1 {{Unresolved requirements: UInt16, UInt32, UInt8}}
    let scope = ImplicitScope()
    defer { scope.end() }

    let nested = FooNested(scope)
    nested.g(scope)
    FooNested.f(scope)
  }
}

extension Foo {
  private struct FooNested {
    init(_: ImplicitScope) {
      @Implicit()
      var i: UInt8
    }

    func g(_: ImplicitScope) {
      @Implicit()
      var i: UInt16
    }

    static func f(_: ImplicitScope) {
      @Implicit()
      var i: UInt32
    }
  }
}

private final class Bar {
  func bar(_: ImplicitScope) {
    @Implicit()
    var uint16: UInt16
  }
}

private enum ResolutionWithoutFullNamespace {
  fileprivate static func eFunction1(_: ImplicitScope) {
    @Implicit()
    var v1: UInt8
  }

  struct SubType {}
}

extension ResolutionWithoutFullNamespace.SubType {
  fileprivate init(_: ImplicitScope) {
    @Implicit()
    var v1: UInt32
  }
}

extension ResolutionWithoutFullNamespace {
  private static func eFunction2(_ scope: ImplicitScope) {
    @Implicit()
    var v1: UInt16

    eFunction1(scope)
    _ = SubType(scope)
  }

  private static func entry() {
    // expected-error@+1 {{Unresolved requirements: UInt16, UInt32, UInt8}}
    let scope = ImplicitScope()
    defer { scope.end() }

    eFunction2(scope)
  }
}
