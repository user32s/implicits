// Copyright 2025 Yandex LLC. All rights reserved.

import Implicits

@_spi(Implicits)
import ShowcaseDependency

public typealias Planet = String

public final class DeathStar {
  public init() {}

  // FIXME: Make it public, fix codegen
  internal func destroy(_ planet: Planet, _ scope: ImplicitScope) {
    @Implicit(\.authority)
    var authority: Bool
    guard authority else {
      print("Unable to destroy \(planet)! Not enough authority.")
      return
    }

    @Implicit(\.laserPower)
    var laserPower: Int

    @Implicit(\.target)
    var target: String

    let laserStatus = laser(scope)
    let shieldStatus = shield(scope)
    let tractorStatus = tractorBeam(scope)

    print(
      "👽 Firing Death Star laser at \(planet) with power \(laserPower)! Target: \(target). Status: \(laserStatus) BOOM! 💥"
    )
    print("🛡️ Shield report: \(shieldStatus)")
    print("🧲 Tractor beam: \(tractorStatus)")
  }
}

extension ImplicitsKeys {
  public static let authority = Key<Bool>()
}
