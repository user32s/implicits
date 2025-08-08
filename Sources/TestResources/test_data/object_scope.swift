import Implicits

private func entry1_initAndMemberAndStaticFunctions() {
  // expected-error@+1 {{Unresolved requirements: Bool, Int16, Int32, Int64, Int8}}
  let scope = ImplicitScope()
  defer { scope.end() }

  S1.f(scope)
  let s: S1 = S1(scope)
  s.f(scope)
  s.fInExtension(scope)
}

private func entry1_2_onlyInit() {
  // expected-error@+1 {{Unresolved requirements: Int16, Int8}}
  let scope = ImplicitScope()
  defer { scope.end() }

  let s: S1 = S1(scope)
  _ = s
}

private func entry1_3_onlyMemberFunction() {
  // expected-error@+1 {{Unresolved requirement: Int32}}
  let scope = ImplicitScope()
  defer { scope.end() }

  let s: S1 = absurdConstructor()

  s.f(scope)
}

private func entry2_nestedTypes() {
  // expected-error@+1 {{Unresolved requirements: UInt16, UInt32, UInt64, UInt8}}
  let scope = ImplicitScope()
  defer { scope.end() }

  S1.S2.f(scope)
  let s: S1.S2 = S1.S2(scope)
  s.f(scope)
}

private func entry3_NotConsideringFunctionsWithoutEnoughtVisibility() {
  // expected-error@+1 {{Unresolved requirement: UInt8}}
  let scope = ImplicitScope()
  defer { scope.end() }

  S3.f(scope)
}

private func entry4_ActorsAndAsyncFunctions() async {
  // expected-error@+1 {{Unresolved requirement: Int8}}
  let scope = ImplicitScope()
  defer { scope.end() }

  let a: A1 = A1()
  await a.f(scope)
}

private func entry5_ResolvingNamespaceOfFunctionParameters(s: S1.S2) async {
  // expected-error@+1 {{Unresolved requirement: UInt32}}
  let scope = ImplicitScope()
  defer { scope.end() }

  s.f(scope)
}

private struct S12_ResolvingNamespaceOfInitParameters {
  init(_ s: S1.S2) {
    // expected-error@+1 {{Unresolved requirement: UInt32}}
    let scope = ImplicitScope()
    defer { scope.end() }

    s.f(scope)
  }
}

private struct S1 {
  fileprivate struct S2 {
    @Implicit()
    var i: UInt8

    init(_: ImplicitScope) {
      @Implicit()
      var i: UInt16
    }

    func f(_: ImplicitScope) {
      @Implicit()
      var i: UInt32
    }

    static func f(_: ImplicitScope) {
      @Implicit()
      var i: UInt64
    }
  }

  @Implicit()
  var foo: Int8

  init(_: ImplicitScope) {
    @Implicit()
    var i: Int16
  }

  func f(_: ImplicitScope) {
    @Implicit()
    var j: Int32
  }

  static func f(_: ImplicitScope) {
    @Implicit()
    var k: Int64
  }
}

private struct S2 {
  // expected-error@+1 {{Type with '@Implicit' stored properties or stored implicits bag must have an initializer with 'scope' argument}}
  @Implicit()
  var foo: UInt16
}

private enum S3 {
  static func f(i: Int = 0, _: ImplicitScope) {
    @Implicit()
    var i: UInt8
  }

  private static func f(j: String = "", _: ImplicitScope) {
    @Implicit()
    var i: UInt16
  }
}

extension S1 {
  func fInExtension(_: ImplicitScope) {
    @Implicit()
    var j: Bool
  }
}

actor A1 {
  func f(_: ImplicitScope) {
    @Implicit()
    var i: Int8
  }
}

func absurdConstructor<T>() -> T {
  fatalError()
}
