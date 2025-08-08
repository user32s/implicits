// Copyright 2023 Yandex LLC. All rights reserved.

import SwiftDiagnostics
import SwiftSyntax

package struct SimpleDiagnostics: DiagnosticMessage {
  package var message: String
  package var severity: DiagnosticSeverity

  package var diagnosticID: MessageID {
    .init(domain: "ImplicitsToolMacros", id: "SimpleDiagnostics")
  }

  package init(_ message: String, severity: DiagnosticSeverity) {
    self.message = message
    self.severity = severity
  }
}

extension DiagnosticMessage where Self == SimpleDiagnostics {
  package static func error(_ msg: String) -> Self {
    SimpleDiagnostics(msg, severity: .error)
  }

  package static func warning(_ msg: String) -> Self {
    SimpleDiagnostics(msg, severity: .warning)
  }

  package static func note(_ msg: String) -> Self {
    SimpleDiagnostics(msg, severity: .note)
  }
}

extension DiagnosticsError {
  package static func at(
    _ location: SyntaxProtocol,
    _ message: String
  ) -> Self {
    .init(diagnostics: [
      Diagnostic(
        node: location, message: .error(message)
      ),
    ])
  }
}
