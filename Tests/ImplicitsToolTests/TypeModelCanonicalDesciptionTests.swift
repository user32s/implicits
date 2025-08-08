// Copyright 2024 Yandex LLC. All rights reserved.

import XCTest

import ImplicitsTool
import SwiftParser
import SwiftSyntax

final class TypeModelCanonicalDesciptionTests: XCTestCase {
  func testSimple() {
    check("Foo")
    check(" Foo  ", "Foo")
  }

  func testGeneric() {
    check("Foo<Bar>")
    check(" Foo< Bar , Baz > ", "Foo<Bar, Baz>")
  }

  func testOptional() {
    check("Foo?")
  }

  func testUnwrappedOptional() {
    check("Foo!")
  }

  func testTuple() {
    check("(Foo, Bar)")
    check("(Foo,Bar)", "(Foo, Bar)")
    check("(foo:Foo,  bar  :  Bar  )", "(foo: Foo, bar: Bar)")
  }

  func testMember() {
    check("Foo.Bar")
  }

  func testArray() {
    check("[Foo]")
  }

  func testAttributed() {
    check("@foo Bar")
    check("@foo @bar Baz")
    check("@foo(bar: baz) Qux")
    check("@[Bar] Baz")
    check("@[Bar: Baz] Qux")
    check("@Foo(bar: baz) Qux")
    check("@Foo(bar: 1) Qux", "@Foo(bar: UNPARSED_ARGUMENT) Qux")
    check("@ [ Bar : Baz] (bar: baz) Qux", "@[Bar: Baz](bar: baz) Qux")
    check("borrowing Bar")
    check("  __shared   Bar ", "__shared Bar")
  }

  func testClassRestriction() {
    // Only valid in protocol restrictions, which SyntaxTree doesn't support yet
  }

  func testComposition() {
    check("Foo & Bar & Baz")
  }

  func testDictionary() {
    check("[Foo: Bar]")
    check("[Foo:Bar]", "[Foo: Bar]")
    check("[Foo : Bar]", "[Foo: Bar]")
    check("[  Foo  :  Bar  ]", "[Foo: Bar]")
  }

  func testFunction() {
    check("(Foo) -> Bar")
    check("(Foo)->Bar", "(Foo) -> Bar")
    check("( _ foo : Foo, _ bar:Bar) -> Baz", "(_ foo: Foo, _ bar: Bar) -> Baz")
    check("(@escaping () throws -> Foo) async -> Bar")
  }

  func testMetatype() {
    check("Foo.Type")
    check("Foo.Protocol")
  }

  func testNamedOpaqueReturn() {
    check("<each Foo: Bar> Foo")
  }

  func testPackElement() {
    check("each Foo")
  }

  func testPackExpansion() {
    check("repeat Foo")
  }

  func testSomeOrAny() {
    check("some Foo")
  }

  func testSuppressed() {
    check("~Foo")
  }

  func testNested() {
    check("@escaping (Foo<[(dict: [Bar: P1 & P2], Baz.Qux!?)]>) -> Void")
  }
}

enum Policy {
  case varDeclType

  func makeSource(_ src: String) -> String {
    switch self {
    case .varDeclType:
      "let a: \(src) = b()"
    }
  }

  func extract<S>(
    _ topLevel: SyntaxTree<S>.TopLevelEntity
  ) -> SyntaxTree<S>.TypeModel? {
    switch self {
    case .varDeclType:
      guard case let .declaration(.variable(variable)) = topLevel.value else {
        return nil
      }
      return variable.bindings.first?.type
    }
  }
}

func check(
  _ input: String, _ output: String? = nil, policy: Policy = .varDeclType
) {
  let output = output ?? input
  let tree = Parser.parse(source: policy.makeSource(input))
  let sxtTree = SyntaxTree.build(
    tree,
    ifConfig: .unknown,
  )
  let tl = sxtTree.first
  guard let got = tl.flatMap({ policy.extract($0)?.description }) else {
    return XCTFail("Failed to extract type model")
  }
  XCTAssertEqual(got, output)
}
