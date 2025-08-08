// Copyright 2025 Yandex LLC. All rights reserved.

@freestanding(expression)
public macro implicits() -> Implicits = #externalMacro(
  module: "ImplicitsMacros",
  type: "ImplicitMacro"
)
