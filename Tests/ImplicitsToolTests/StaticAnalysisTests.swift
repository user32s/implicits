// Copyright 2023 Yandex LLC. All rights reserved.

import XCTest

final class StaticAnalysisTests: XCTestCase {
  func testSyntaxStructure() {
    verify(file: "syntax_structure.swift")
  }

  func testBasicGraph() {
    verify(file: "graph_basic.swift")
  }

  func testNestedScopes() {
    verify(file: "nested_scope.swift")
  }

  func testRecursion() {
    verify(file: "graph_recursion.swift")
  }

  func testObjectScope() {
    verify(file: "object_scope.swift")
  }

  func testSymbolResolution() {
    verify(file: "symbol_resolution.swift")
  }

  func testImplicitBag() {
    verify(file: "implicit_bag.swift")
  }

  func testStoredImplicitBag() {
    verify(file: "stored_implicit_bag.swift")
  }

  func testImplicitScopeOrder() {
    verify(file: "implicit_scope_order.swift")
  }

  func testKeyResolving() {
    verify(file: "key_resolving.swift")
  }

  func testExpressions() {
    verify(file: "expressions.swift")
  }

  func testImplicitMap() {
    verify(file: "implicit_map.swift")
  }

  func testWithScope() {
    verify(file: "with_scope.swift")
  }

  func testGeneratedInit() {
    verify(file: "generated_init.swift")
  }

  func testTypeResolution() {
    verify(file: "type_resolution.swift")
  }

  func testMultipleFileResolution() {
    verify(files: [
      "multiple_file_resolution_f1.swift",
      "multiple_file_resolution_f2.swift",
    ])
  }

  func testUsingImplicitInterface() {
    verify(
      files: [
        "using_implicit_interface.swift",
      ],
      dependencies: [anotherModule]
    )
  }

  func testUsingTestableImplicitInterface() {
    verify(
      files: [
        "using_testable_implicit_interface.swift",
      ],
      dependencies: [anotherModule]
    )
  }

  func testExporting() {
    verify(file: "exporting.swift", enableExporting: true)
  }

  func testSupportFile() {
    verify(
      files: ["support_file.swift"],
      enableExporting: true,
      supportFile: "support_file_snapshot.swift",
      dependencies: [
        (modulename: "AnotherModule", files: ["another_module.swift"]),
      ]
    )
  }
}

private let anotherModule = (modulename: "AnotherModule", files: ["another_module.swift"])
