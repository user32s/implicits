// Copyright 2023 Yandex LLC. All rights reserved.

import Foundation

#if !PACKAGE_MANAGER
// keep import in code to make sure the complitaion of test sources
// is checked in tests
private import ImplicitsToolTestSources // nocodeanalyzer
#endif

public final class TestSupport {
  init() {} // to prevent swiftFormat from turning it into an enum

  public static func readFile(_ name: String) -> String {
    let resourceURL = URL(
      fileURLWithPath: bundle.resourceURL!.path + "/test_data/" + name
    )
    return try! String(contentsOf: resourceURL, encoding: .utf8)
  }

  public static func pathToSourceFile(_ name: String) -> String {
    var currentURL = URL(fileURLWithPath: #file)
    currentURL.deleteLastPathComponent()
    currentURL.append(path: "test_data", directoryHint: .isDirectory)
    currentURL.appendPathComponent(name)
    return currentURL.path
  }
}

#if PACKAGE_MANAGER
private let bundle = Bundle.module
#else
private let bundle = Bundle(for: TestSupport.self)
#endif
