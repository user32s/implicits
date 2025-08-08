import Implicits

func requiresInt8(_: ImplicitScope) {
  @Implicit()
  var i: Int8
}

private func privateFunc(_: ImplicitScope) {
  @Implicit()
  var i: File2
}

struct Internal {}
func internalPrivateFunc(a: Int, _: ImplicitScope) {
  @Implicit()
  var i: Internal
}

struct Private {}
private func internalPrivateFunc(a: String, _: ImplicitScope) {
  @Implicit()
  var i: Private
}

struct IntPublic {}
struct IntPrivate {}

public extension Int {
  static func publicPrivateFunc(a: Int, _: ImplicitScope) {
    @Implicit()
    var i: IntPublic
  }

  fileprivate static func publicPrivateFunc(a: String, _: ImplicitScope) {
    @Implicit()
    var i: IntPrivate
  }
}
