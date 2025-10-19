import SwiftUI

#if os(macOS)
import AppKit
/// Platform-specific font type alias for macOS.
public typealias PlatformFont = NSFont
#else
import UIKit
/// Platform-specific font type alias for iOS.
public typealias PlatformFont = UIFont
#endif

/// Font configuration for different markdown elements.
///
/// `FontConfiguration` defines the fonts used for various markdown elements
/// such as body text, headings, code blocks, and more.
///
/// ## Topics
/// ### Creating Font Configurations
/// - ``init(body:heading1:heading2:heading3:heading4:heading5:heading6:code:codeBlock:blockquote:)``
/// - ``default``
///
/// ### Font Properties
/// - ``body``
/// - ``heading1``
/// - ``heading2``
/// - ``heading3``
/// - ``heading4``
/// - ``heading5``
/// - ``heading6``
/// - ``code``
/// - ``codeBlock``
/// - ``blockquote``
public struct FontConfiguration {
    /// Font for body text.
    public let body: PlatformFont

    /// Font for level 1 headings.
    public let heading1: PlatformFont

    /// Font for level 2 headings.
    public let heading2: PlatformFont

    /// Font for level 3 headings.
    public let heading3: PlatformFont

    /// Font for level 4 headings.
    public let heading4: PlatformFont

    /// Font for level 5 headings.
    public let heading5: PlatformFont

    /// Font for level 6 headings.
    public let heading6: PlatformFont

    /// Font for inline code.
    public let code: PlatformFont

    /// Font for code blocks.
    public let codeBlock: PlatformFont

    /// Font for blockquotes.
    public let blockquote: PlatformFont

    /// Creates a new font configuration.
    ///
    /// - Parameters:
    ///   - body: Font for body text. Defaults to system font at 14pt.
    ///   - heading1: Font for level 1 headings. Defaults to bold system font at 28pt.
    ///   - heading2: Font for level 2 headings. Defaults to bold system font at 24pt.
    ///   - heading3: Font for level 3 headings. Defaults to bold system font at 20pt.
    ///   - heading4: Font for level 4 headings. Defaults to bold system font at 18pt.
    ///   - heading5: Font for level 5 headings. Defaults to bold system font at 16pt.
    ///   - heading6: Font for level 6 headings. Defaults to bold system font at 14pt.
    ///   - code: Font for inline code. Defaults to monospaced system font at 13pt.
    ///   - codeBlock: Font for code blocks. Defaults to monospaced system font at 12pt.
    ///   - blockquote: Font for blockquotes. Defaults to system font at 14pt.
    public init(
        body: PlatformFont = .systemFont(ofSize: 14),
        heading1: PlatformFont = .boldSystemFont(ofSize: 28),
        heading2: PlatformFont = .boldSystemFont(ofSize: 24),
        heading3: PlatformFont = .boldSystemFont(ofSize: 20),
        heading4: PlatformFont = .boldSystemFont(ofSize: 18),
        heading5: PlatformFont = .boldSystemFont(ofSize: 16),
        heading6: PlatformFont = .boldSystemFont(ofSize: 14),
        code: PlatformFont = .monospacedSystemFont(ofSize: 13, weight: .regular),
        codeBlock: PlatformFont = .monospacedSystemFont(ofSize: 12, weight: .regular),
        blockquote: PlatformFont = .systemFont(ofSize: 14)
    ) {
        self.body = body
        self.heading1 = heading1
        self.heading2 = heading2
        self.heading3 = heading3
        self.heading4 = heading4
        self.heading5 = heading5
        self.heading6 = heading6
        self.code = code
        self.codeBlock = codeBlock
        self.blockquote = blockquote
    }

    /// Default font configuration with standard system fonts.
    nonisolated(unsafe) public static let `default` = FontConfiguration()
}
