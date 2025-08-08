// Copyright 2024 Yandex LLC. All rights reserved.

/// Represents a diagnostic message produced by the tool.
public struct Diagnostic: Hashable, Codable, Sendable {
  public enum Severity: Hashable, Codable, Sendable {
    case error
    case warning
    case note
  }

  public struct Location: Hashable, Codable, Sendable {
    public var file: String
    public var line: Int
    public var column: Int
    public var columnEnd: Int?

    public init(file: String, line: Int, column: Int, columnEnd: Int? = nil) {
      self.file = file
      self.line = line
      self.column = column
      self.columnEnd = columnEnd
    }
  }

  public var severity: Severity
  public var message: String
  public var codeLine: String
  public var loc: Location

  public init(severity: Severity, message: String, codeLine: String, loc: Location) {
    self.severity = severity
    self.message = message
    self.codeLine = codeLine
    self.loc = loc
  }
}

extension Diagnostic.Severity {
  public func render() -> String {
    switch self {
    case .error: "error"
    case .warning: "warning"
    case .note: "note"
    }
  }
}

extension Diagnostic {
  public func swiftcLikeRender() -> String {
    """
    \(loc.file):\(loc.line): \(severity.render()): \(message)
    \(codeLine)
    """
  }
}

public typealias ImplicitToolDiagnostic = Diagnostic
