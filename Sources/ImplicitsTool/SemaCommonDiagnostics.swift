// Copyright 2024 Yandex LLC. All rights reserved.

extension DiagnosticMessage {
  typealias Symbol = CallableSignature
  // Symbol resolution
  static func unresolvedSymbol(_ symbol: Symbol) -> Self {
    "Unresolved symbol '\(symbol)'"
  }

  static func ambiguousUseOf(_ symbol: Symbol) -> Self {
    "Ambiguous use of '\(symbol)'"
  }

  static let foundCandidate: Self = "Found this candidate"
}
