// Copyright 2025 Yandex LLC. All rights reserved.

import Implicits

@_spi(Implicits)
public func laser(_: ImplicitScope) -> String {
  @Implicit(\.target)
  var target: String
  @Implicit(\.laserPower)
  var laserPower: Int

  // Use the implicit value in some way
  print("Target acquired: \(target)")

  return "Laser locked on \(target)!"
}

@_spi(Implicits)
public func shield(_: ImplicitScope) -> String {
  @Implicit(\.shieldLevel)
  var shieldLevel: Int

  print("Shield level: \(shieldLevel)")
  return "Shields at level \(shieldLevel)!"
}

@_spi(Implicits)
public func tractorBeam(_: ImplicitScope) -> String {
  @Implicit(\.beamStrength)
  var beamStrength: Int

  print("Tractor beam strength: \(beamStrength)")
  return "Tractor beam set to \(beamStrength)!"
}

extension ImplicitsKeys {
  public static let target = Key<String>()
  public static let shieldLevel = Key<Int>()
  public static let beamStrength = Key<Int>()
  public static let laserPower = Key<Int>()
}
