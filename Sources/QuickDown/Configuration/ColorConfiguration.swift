import SwiftUI

#if os(macOS)
import AppKit
/// Platform-specific color type alias for macOS.
public typealias PlatformColor = NSColor
#else
import UIKit
/// Platform-specific color type alias for iOS.
public typealias PlatformColor = UIColor
#endif

/// Color configuration for different markdown elements.
///
/// `ColorConfiguration` defines the colors used for various markdown elements
/// such as body text, headings, code blocks, links, and more.
///
/// ## Topics
/// ### Creating Color Configurations
/// - ``init(text:heading:code:codeBlockBackground:blockquoteText:blockquoteBackground:link:selection:)``
/// - ``default``
///
/// ### Color Properties
/// - ``text``
/// - ``heading``
/// - ``code``
/// - ``codeBlockBackground``
/// - ``blockquoteText``
/// - ``blockquoteBackground``
/// - ``link``
/// - ``selection``
public struct ColorConfiguration {
    /// Color for body text.
    public let text: PlatformColor

    /// Color for headings.
    public let heading: PlatformColor

    /// Color for inline code and code blocks.
    public let code: PlatformColor

    /// Background color for code blocks.
    public let codeBlockBackground: PlatformColor

    /// Text color for blockquotes.
    public let blockquoteText: PlatformColor

    /// Background color for blockquotes.
    public let blockquoteBackground: PlatformColor

    /// Color for links.
    public let link: PlatformColor

    /// Color for selected text.
    public let selection: PlatformColor

    /// Creates a new color configuration.
    ///
    /// - Parameters:
    ///   - text: Color for body text. Defaults to label color.
    ///   - heading: Color for headings. Defaults to label color.
    ///   - code: Color for code. Defaults to system red.
    ///   - codeBlockBackground: Background color for code blocks. Defaults to light gray.
    ///   - blockquoteText: Text color for blockquotes. Defaults to secondary label color.
    ///   - blockquoteBackground: Background color for blockquotes. Defaults to light gray.
    ///   - link: Color for links. Defaults to system blue.
    ///   - selection: Color for selected text. Defaults to system blue with alpha.
    public init(
        text: PlatformColor? = nil,
        heading: PlatformColor? = nil,
        code: PlatformColor? = nil,
        codeBlockBackground: PlatformColor? = nil,
        blockquoteText: PlatformColor? = nil,
        blockquoteBackground: PlatformColor? = nil,
        link: PlatformColor? = nil,
        selection: PlatformColor? = nil
    ) {
        self.text = text ?? PlatformColor.defaultLabelColor
        self.heading = heading ?? PlatformColor.defaultLabelColor
        self.code = code ?? PlatformColor.defaultSystemRed
        self.codeBlockBackground = codeBlockBackground ?? PlatformColor.defaultCodeBlockBackgroundColor
        self.blockquoteText = blockquoteText ?? PlatformColor.defaultSecondaryLabelColor
        self.blockquoteBackground = blockquoteBackground ?? PlatformColor.defaultBlockquoteBackgroundColor
        self.link = link ?? PlatformColor.defaultSystemBlue
        self.selection = selection ?? PlatformColor.defaultSelectionColor
    }

    /// Default color configuration with standard system colors.
    nonisolated(unsafe) public static let `default` = ColorConfiguration()
}

// MARK: - Platform Color Extensions

extension PlatformColor {
    #if os(macOS)
    static var defaultLabelColor: NSColor { .labelColor }
    static var defaultSecondaryLabelColor: NSColor { .secondaryLabelColor }
    static var defaultSystemRed: NSColor { .systemRed }
    static var defaultSystemBlue: NSColor { .systemBlue }
    static var defaultCodeBlockBackgroundColor: NSColor { NSColor(white: 0.95, alpha: 1.0) }
    static var defaultBlockquoteBackgroundColor: NSColor { NSColor(white: 0.97, alpha: 1.0) }
    static var defaultSelectionColor: NSColor { .selectedTextBackgroundColor }
    #else
    static var defaultLabelColor: UIColor { .label }
    static var defaultSecondaryLabelColor: UIColor { .secondaryLabel }
    static var defaultSystemRed: UIColor { .systemRed }
    static var defaultSystemBlue: UIColor { .systemBlue }
    static var defaultCodeBlockBackgroundColor: UIColor { UIColor(white: 0.95, alpha: 1.0) }
    static var defaultBlockquoteBackgroundColor: UIColor { UIColor(white: 0.97, alpha: 1.0) }
    static var defaultSelectionColor: UIColor { .systemBlue.withAlphaComponent(0.3) }
    #endif
}
