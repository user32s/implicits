import XCTest

@_spi(Unsafe) internal import Implicits

final class WithScopeTests: XCTestCase {
  func testWithScope() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(\.id)
    var value = 42

    withScope { scope in
      @Implicit(\.id)
      var value = 200
      XCTAssertEqual(value, 200)

      do {
        let scope = scope.nested()
        defer { scope.end() }

        @Implicit(\.id)
        var value = 300
        XCTAssertEqual(value, 300)
      }

      XCTAssertEqual(value, 200)
    }

    XCTAssertEqual(value, 42)
  }

  func testWithScopeThrows() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(\.id)
    var value = 42

    do {
      try withScope { _ in
        @Implicit(\.id)
        var value = 300
        XCTAssertEqual(value, 300)
        throw NSError(domain: "Test", code: 1, userInfo: nil)
      }
      XCTFail("Should have thrown")
    } catch {
      XCTAssertEqual(value, 42)
    }
  }
}
