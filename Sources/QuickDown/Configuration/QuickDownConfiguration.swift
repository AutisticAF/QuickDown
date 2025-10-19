import SwiftUI

/// Configuration for customizing the appearance and behavior of QuickDown markdown rendering.
///
/// `QuickDownConfiguration` allows you to customize fonts, colors, paragraph settings,
/// and other visual aspects of rendered markdown content.
///
/// ## Topics
/// ### Creating a Configuration
/// - ``init(fontConfiguration:colorConfiguration:paragraphConfiguration:)``
///
/// ### Accessing Configuration Properties
/// - ``fontConfiguration``
/// - ``colorConfiguration``
/// - ``paragraphConfiguration``
public struct QuickDownConfiguration {
    /// Font configuration for different markdown elements.
    public let fontConfiguration: FontConfiguration

    /// Color configuration for different markdown elements.
    public let colorConfiguration: ColorConfiguration

    /// Paragraph spacing and layout configuration.
    public let paragraphConfiguration: ParagraphConfiguration

    /// Creates a new QuickDown configuration.
    ///
    /// - Parameters:
    ///   - fontConfiguration: Font settings for markdown elements. Defaults to ``FontConfiguration/default``.
    ///   - colorConfiguration: Color settings for markdown elements. Defaults to ``ColorConfiguration/default``.
    ///   - paragraphConfiguration: Paragraph layout settings. Defaults to ``ParagraphConfiguration/default``.
    public init(
        fontConfiguration: FontConfiguration = .default,
        colorConfiguration: ColorConfiguration = .default,
        paragraphConfiguration: ParagraphConfiguration = .default
    ) {
        self.fontConfiguration = fontConfiguration
        self.colorConfiguration = colorConfiguration
        self.paragraphConfiguration = paragraphConfiguration
    }

    /// Default configuration with standard settings.
    nonisolated(unsafe) public static let `default` = QuickDownConfiguration()
}
