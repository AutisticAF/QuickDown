# QuickDown

This document outlines the purpose, features, requirements, and guidelines for QuickDown.

---

## Purpose

QuickDown is a Swift library that adds rich, Github-flavored Markdown rendering to SwiftUI.

## Features

1. Full support for Github-flavored Markdown syntax (use `swift-markdown` for parsing).
2. Fully customizable and configurable.
3. Supports both macOS and iOS.
4. The ability to highlight and select ranges within the text view.
5. Text search/find.
6. Smooth scrolling of long content.
7. Support for LTR and RTL layouts.
8. Programatically scroll to any text range.

## Customizability

1. Fonts and colors
2. Paragraph settings, like line height, and distance between paragraphs.

## Codebase Requirements

QuickDown will be released as a public library, so it must be:

1. **Well-Organized**: Each class, struct, protocol, and enum must reside in their own, individual file. Files must be organized in a logical folder structure.
2. **Well-Documented**: Every class, struct, protocol, and enum must be thoroughly documented in DocC format. Functions and properties must also be documented in the same way. Additionally, there must be a README.md file describing the library, how to install and use it, etc.
3. **Well-Tested**: The library must be thoroughly unit tested using Swift Testing. It must also be UI tested via XCUITest.
4. **Swift 6.2 Compliant**: The library must fully support Swift Concurrency.

## Other Requirements

1. Third-party Swift libraries may be used, so long as they are actively maintained.
2. QuickDown must be built on top of CoreText 2.