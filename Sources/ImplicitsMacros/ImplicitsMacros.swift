// Copyright 2023 Yandex LLC. All rights reserved.

import Foundation

import ImplicitsShared
import MacroUtils
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ImplicitMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax {
    guard let loc = context.location(of: node),
          let fileExpansion = loc.filename else {
      throw DiagnosticsError.at(node, "Unable to get source location")
    }
    let moduleAndFile = fileExpansion.split(separator: "/")
    guard let fileName = moduleAndFile.last else {
      throw DiagnosticsError.at(node, "Unable to get file name")
    }
    let funcName = generateImplicitBagFuncName(
      filename: String(fileName),
      line: loc.line.trimmedDescription,
      column: loc.column.trimmedDescription
    )
    return "\(raw: funcName)()"
  }
}

extension AbstractSourceLocation {
  var filename: String? {
    switch file.as(ExprSyntaxEnum.self) {
    case let .stringLiteralExpr(literal):
      literal.representedLiteralValue
    default:
      nil
    }
  }
}

@main
struct ImplicitsToolMacros: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    ImplicitMacro.self,
  ]
}
