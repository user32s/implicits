@_spi(Unsafe)
import Implicits

private func entry1() {
  // expected-error@+1 {{Unresolved requirements: Int16, Int8, UInt32, UInt64, UInt8}}
  let scope = ImplicitScope()
  defer { scope.end() }

  let closure1 = { [implicits = testBagImplicits()] in
    let scope = ImplicitScope(with: implicits)
    defer { scope.end() }

    @Implicit()
    var i: UInt8
  }
  closure1()

  let closure2 = { [foo = testBagBad()] in
    // expected-error@+2 {{Invalid 'with:' parameter, expected 'implicits' identifier}}
    // expected-error@+1 {{Unresolved requirement: [UInt16]}}
    let scope = ImplicitScope(with: foo)
    defer { scope.end() }

    @Implicit()
    var i: [UInt16]
  }
  closure2()

  let closure3 = { [implicits = testBagImplicits()] in
    let closure3_1 = {
      let scope = ImplicitScope(with: implicits)
      defer { scope.end() }

      @Implicit()
      var i: UInt32
    }
    closure3_1()
  }
  closure3()

  // Multiple bag usage
  let closure4 = { [implicits = testBagImplicits()] in
    if Bool.random() {
      let scope = ImplicitScope(with: implicits)
      defer { scope.end() }

      @Implicit()
      var i: UInt64
    } else {
      let scope = ImplicitScope(with: implicits)
      defer { scope.end() }

      @Implicit()
      var i: Int8
    }
  }
  closure4()

  let nestedBagsWithNestedScope = { [implicits = testBagImplicits()] in
    let scope = ImplicitScope(with: implicits)
    defer { scope.end() }

    let c1 = { [implicits = testBag()] in
      let scope = ImplicitScope(with: implicits)
      defer { scope.end() }

      @Implicit()
      var i: Int16
    }
    c1()
  }
  nestedBagsWithNestedScope()

  let nestedBagsWithoutScope = { [implicits = testBagImplicits()] in
    _ = implicits
    // expected-error@+1 {{Using implicits without 'ImplicitScope'}}
    let c1 = { [implicits = testBag()] in
      let scope = ImplicitScope(with: implicits)
      defer { scope.end() }

      @Implicit()
      var i: [Int32]
    }
    c1()

    if Bool.random() {
      let scope = ImplicitScope(with: implicits)
      defer { scope.end() }

      @Implicit()
      var i: UInt8
    }
  }
  nestedBagsWithoutScope()

  // expected-error@+1 {{Unused bag}}
  _ = { [implicits = testBagImplicits()] in
    _ = implicits
    // expected-error@+1 {{Unresolved requirement: UInt8}}
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit()
    var i: UInt8
  }

  let implicits = testBagImplicits()
  let usingUnknownBag = {
    let scope = ImplicitScope(with: implicits) // expected-error {{Using unknown bag}}
    defer { scope.end() }

    @Implicit()
    var i: [Int8]
  }
  usingUnknownBag()
}

// Closures without bags don't inherit outer scope
private func entry2() {
  // expected-error@+1 {{Unresolved requirement: UInt16}}
  let scope = ImplicitScope()
  defer { scope.end() }

  @Implicit()
  var v1: UInt8 = 0

  @Implicit()
  var v2: UInt16

  let closure1 = {
    // expected-error@+1 {{Unresolved requirements: UInt32, UInt8}}
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit()
    var v3: UInt8

    @Implicit()
    var v4: UInt32
  }
  closure1()
}

private func entry_bagsWithMacros() {
  // expected-error@+1 {{Unresolved requirement: UInt8}}
  let scope = ImplicitScope()
  defer { scope.end() }

  let closure1 = { [implicits = #implicits] in
    let scope = ImplicitScope(with: implicits)
    defer { scope.end() }

    @Implicit()
    var v3: UInt8
  }
  closure1()
}

private func __implicit_bag_implicit_bag_swift_149_33() -> Implicits {
  Implicits()
}

private func testBagImplicits() -> Implicits {
  Implicits()
}

private func testBag() -> Implicits {
  Implicits()
}

private func testBagBad() -> Implicits {
  Implicits()
}
