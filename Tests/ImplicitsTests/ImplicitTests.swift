// Copyright 2022 Yandex LLC. All rights reserved.

import XCTest

@_spi(Unsafe) internal import Implicits

final class ImplicitTests: XCTestCase {
  func testDeclaringAndRetreivingImplicitArg() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(\.id)
    var pass = 1

    @Implicit(\.id)
    var retrieve: Int

    XCTAssertEqual(retrieve, 1)
  }

  func testPassingImplicitArgToFunction() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(\.id)
    var id = 2

    XCTAssertEqual(get(\.id, scope), 2)
  }

  func testPassingImplicitArgToStructField() {
    let scope = ImplicitScope()
    defer { scope.end() }

    struct WithID {
      @Implicit(\.id)
      var id

      init(_: ImplicitScope) {}
    }

    @Implicit(\.id)
    var id = 3

    XCTAssertEqual(WithID(scope).id, 3)
  }

  func testPassingMultipleImplicitArgsToStructFields() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(\.id)
    var id = 3

    @Implicit(\.launchID)
    var launchID = 4

    @Implicit(\.deviceID)
    var deviceID = { 5 }

    let res = MultipleIDs(scope)

    XCTAssertEqual(res.id, 3)
    XCTAssertEqual(res.launchID, 4)
    XCTAssertEqual(res.deviceID(), 5)
  }

  func testPushingContext() {
    func declareAndCheck(_ id: Int, _ scope: ImplicitScope) {
      let scope = scope.nested()
      defer { scope.end() }

      @Implicit(\.id)
      var id = id
      XCTAssertEqual(get(\.id, scope), id)
    }

    let scope = ImplicitScope()
    defer { scope.end() }

    declareAndCheck(1, scope)

    @Implicit(\.id)
    var id = 2

    declareAndCheck(3, scope)

    XCTAssertEqual(get(\.id, scope), 2)

    declareAndCheck(4, scope)
  }

  func testImplicitInMultipleThreadsAreIndependant() {
    let t1Pushed = DispatchSemaphore(value: 0)
    let t2Pushed = DispatchSemaphore(value: 0)
    let t1Declared = DispatchSemaphore(value: 0)
    let t2Declared = DispatchSemaphore(value: 0)
    let t1Retrieved = DispatchSemaphore(value: 0)
    let t2Retrieved = DispatchSemaphore(value: 0)
    let t1Finished = DispatchSemaphore(value: 0)
    let t2Finished = DispatchSemaphore(value: 0)

    let t1 = Thread {
      let scope = ImplicitScope()
      defer { scope.end() }

      t1Pushed.signal()

      // wait for t2 to push context
      t2Pushed.wait()

      @Implicit(\.id)
      var valueForThread1 = 1
      t1Declared.signal()

      // wait for t2 to declare implicit
      t2Declared.wait()

      let got = get(\.id, scope)
      t1Retrieved.signal()

      // wait for t2 to retrieve implicit
      t2Retrieved.wait()

      XCTAssertEqual(got, 1)
      t1Finished.signal()
    }

    let t2 = Thread {
      let scope = ImplicitScope()
      defer { scope.end() }

      // wait for t1 to push context
      t1Pushed.wait()

      t2Pushed.signal()

      // wait for t1 to declare implicit
      t1Declared.wait()

      @Implicit(\.id)
      var valueForThread2 = 2
      t2Declared.signal()

      // wait for t1 to retrieve implicit
      t1Retrieved.wait()

      let got = get(\.id, scope)
      t2Retrieved.signal()

      XCTAssertEqual(got, 2)
      t2Finished.signal()
    }

    t1.start()
    t2.start()

    t1Finished.wait()
    t2Finished.wait()
  }

  func testMultipleImplicitsInMultipleThreadsAreIndependant() {
    let t1Pushed = DispatchSemaphore(value: 0)
    let t2Pushed = DispatchSemaphore(value: 0)
    let t1Declared = DispatchSemaphore(value: 0)
    let t2Declared = DispatchSemaphore(value: 0)
    let t1Retrieved = DispatchSemaphore(value: 0)
    let t2Retrieved = DispatchSemaphore(value: 0)
    let t1Finished = DispatchSemaphore(value: 0)
    let t2Finished = DispatchSemaphore(value: 0)

    let t1 = Thread {
      let scope = ImplicitScope()
      defer { scope.end() }

      t1Pushed.signal()

      // wait for t2 to push context
      t2Pushed.wait()

      @Implicit(\.id)
      var id = 1

      @Implicit(\.launchID)
      var launchID = 2

      @Implicit(\.deviceID)
      var deviceID = { 3 }

      t1Declared.signal()

      // wait for t2 to declare implicit
      t2Declared.wait()

      let got = MultipleIDs(scope)
      t1Retrieved.signal()

      // wait for t2 to retrieve implicit
      t2Retrieved.wait()

      XCTAssertEqual(got.id, 1)
      XCTAssertEqual(got.launchID, 2)
      XCTAssertEqual(got.deviceID(), 3)
      t1Finished.signal()
    }

    let t2 = Thread {
      let scope = ImplicitScope()
      defer { scope.end() }

      // wait for t1 to push context
      t1Pushed.wait()

      t2Pushed.signal()

      // wait for t1 to declare implicit
      t1Declared.wait()

      @Implicit(\.id)
      var id = 4

      @Implicit(\.launchID)
      var launchID = 5

      @Implicit(\.deviceID)
      var deviceID = { 6 }

      t2Declared.signal()

      // wait for t1 to retrieve implicit
      t1Retrieved.wait()

      let got = MultipleIDs(scope)
      t2Retrieved.signal()

      XCTAssertEqual(got.id, 4)
      XCTAssertEqual(got.launchID, 5)
      XCTAssertEqual(got.deviceID(), 6)
      t2Finished.signal()
    }

    t1.start()
    t2.start()

    t1Finished.wait()
    t2Finished.wait()
  }

  func testCapturingImplicits() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(\.id)
    var id = 1
    @Implicit(\.launchID)
    var launchID = 2
    @Implicit(\.deviceID)
    var deviceID = { 3 }

    func withRewritenIDs<T>(
      _ block: () -> T,
      _ scope: ImplicitScope
    ) -> T {
      let scope = scope.nested()
      defer { scope.end() }

      @Implicit(\.id)
      var id = 4
      @Implicit(\.launchID)
      var launchID = 5
      @Implicit(\.deviceID)
      var deviceID = { 6 }

      return block()
    }

    let multipleIDsFactory = {
      [implicits = Implicits(
        unsafeKeys:
        Implicits.getRawKey(\.id),
        Implicits.getRawKey(\.launchID),
        Implicits.getRawKey(\.deviceID)
      )] in
      let scope = ImplicitScope(with: implicits)
      defer { scope.end() }

      return MultipleIDs(scope)
    }

    let got = multipleIDsFactory()
    XCTAssertEqual(got.id, 1)
    XCTAssertEqual(got.launchID, 2)
    XCTAssertEqual(got.deviceID(), 3)

    let got2 = withRewritenIDs(multipleIDsFactory, scope)
    XCTAssertEqual(got2.id, 1)
    XCTAssertEqual(got2.launchID, 2)
    XCTAssertEqual(got2.deviceID(), 3)
  }

  func testTypeKey() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit
    var id = "1"

    @Implicit()
    var got: String
    XCTAssertEqual(got, "1")

    @Implicit
    var id2 = "2"

    @Implicit()
    var got2: String
    XCTAssertEqual(got2, "2")

    let idFactory = {
      [implicits = Implicits(
        unsafeKeys: Implicits.getRawKey(String.self)
      )] in
      let scope = ImplicitScope(with: implicits)
      defer { scope.end() }
      @Implicit()
      var id: String
      return id
    }

    XCTAssertEqual(idFactory(), "2")
  }

  func testMappingKeySpecifierToKeySpecifier() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(\.id)
    var i = 1

    Implicit.map(\.id, to: \.launchID) { $0 }
    Implicit.map(\.id, to: \.deviceID) { id in { id } }

    XCTAssertEqual(get(\.launchID, scope), 1)
    XCTAssertEqual(get(\.deviceID, scope)(), 1)
  }

  func testMappingKeySpecifierToType() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(\.id)
    var i = 1

    Implicit.map(\.id, to: Int.self) { $0 }
    XCTAssertEqual(get(Int.self, scope), 1)
  }

  func testMappingTypeToKeySpecifier() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(Int.self)
    var i = 1

    Implicit.map(Int.self, to: \.id) { $0 }
    XCTAssertEqual(get(\.id, scope), 1)
  }

  func testMappingTypeToType() {
    let scope = ImplicitScope()
    defer { scope.end() }

    @Implicit(Int.self)
    var i = 1

    Implicit.map(Int.self, to: String.self, String.init)
    XCTAssertEqual(get(String.self, scope), "1")
  }
}

enum IDTag {}
typealias ID = ImplicitKey<Int, IDTag>

enum LaunchIDTag {}
typealias LaunchID = ImplicitKey<Int, LaunchIDTag>

enum DeviceIDTag {}
typealias DeviceID = ImplicitKey<() -> Int, DeviceIDTag>

extension ImplicitsKeys {
  var id: ID.Type { ID.self }
  var launchID: LaunchID.Type { LaunchID.self }
  var deviceID: DeviceID.Type { DeviceID.self }
}

func get<Key: ImplicitKeyType>(
  _ ks: KeySpecifier<Key>,
  _: ImplicitScope
) -> Key.Value {
  @Implicit(ks)
  var value
  return value
}

func get<T>(
  _: T.Type,
  _: ImplicitScope
) -> T {
  @Implicit(T.self)
  var value
  return value
}

struct MultipleIDs {
  @Implicit(\.id)
  var id

  @Implicit(\.launchID)
  var launchID

  @Implicit(\.deviceID)
  var deviceID

  init(_: ImplicitScope) {}
}
