import Implicits

// expected-error@+1 {{Public function must be marked with '@_spi(Implicits)' attribute when exporting enabled}}
public func exportedF1(_: ImplicitScope) -> Int {
  @Implicit()
  var v1: Int

  return v1
}

@_spi(Implicits)
public func exportedF2(_: ImplicitScope) -> Int {
  @Implicit()
  var v1: Int

  return v1
}

@_spi(
  Implicits
)
public func exportedF3(_: ImplicitScope) -> Int {
  @Implicit()
  var v1: Int

  return v1
}

public class ExportedClass {
  // expected-error@+1 {{Public function must be marked with '@_spi(Implicits)' attribute when exporting enabled}}
  public final func exportedF1(_: ImplicitScope) -> Int {
    @Implicit()
    var v1: Int

    return v1
  }

  @_spi(Implicits)
  public final func exportedF2(_: ImplicitScope) -> Int {
    @Implicit()
    var v1: Int

    return v1
  }

  // expected-error@+1 {{Public function must be marked with '@_spi(Implicits)' attribute when exporting enabled}}
  public init(_: ImplicitScope) {
    @Implicit()
    var v1: Int
  }
}
