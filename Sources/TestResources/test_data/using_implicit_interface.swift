import AnotherModule
import Implicits

private func entry() {
  // expected-error@+1 {{Unresolved requirement: AnotherModuleStruct}}
  let scope = ImplicitScope()
  defer { scope.end() }

  @Implicit
  var v1 = AnotherModulePublicStruct()

  @Implicit
  var v2 = AnotherModuleNSObject()

  anotherModuleFunction(scope)
}
