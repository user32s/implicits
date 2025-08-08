// Copyright 2025 Yandex LLC. All rights reserved.

package func generateImplicitBagFuncName(
  filename: String, line: String, column: String
) -> String {
  let filename = String(filename.map { $0.isAlphanumeric ? $0 : "_" })
  return "__implicit_bag_\(filename)_\(line)_\(column)"
}

extension Character {
  fileprivate var isAlphanumeric: Bool { isLetter || isNumber }
}
