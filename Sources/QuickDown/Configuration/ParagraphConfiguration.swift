import CoreGraphics

/// Configuration for paragraph spacing and layout.
///
/// `ParagraphConfiguration` controls the spacing between lines and paragraphs,
/// alignment, and other text layout properties.
///
/// ## Topics
/// ### Creating Paragraph Configurations
/// - ``init(lineHeight:paragraphSpacing:headingSpacing:alignment:)``
/// - ``default``
///
/// ### Layout Properties
/// - ``lineHeight``
/// - ``paragraphSpacing``
/// - ``headingSpacing``
/// - ``alignment``
public struct ParagraphConfiguration {
    /// Line height multiplier for body text.
    public let lineHeight: CGFloat

    /// Spacing between paragraphs.
    public let paragraphSpacing: CGFloat

    /// Spacing after headings.
    public let headingSpacing: CGFloat

    /// Text alignment.
    public let alignment: TextAlignment

    /// Creates a new paragraph configuration.
    ///
    /// - Parameters:
    ///   - lineHeight: Line height multiplier. Defaults to 1.3.
    ///   - paragraphSpacing: Spacing between paragraphs in points. Defaults to 12.
    ///   - headingSpacing: Spacing after headings in points. Defaults to 8.
    ///   - alignment: Text alignment. Defaults to natural.
    public init(
        lineHeight: CGFloat = 1.3,
        paragraphSpacing: CGFloat = 12,
        headingSpacing: CGFloat = 8,
        alignment: TextAlignment = .natural
    ) {
        self.lineHeight = lineHeight
        self.paragraphSpacing = paragraphSpacing
        self.headingSpacing = headingSpacing
        self.alignment = alignment
    }

    /// Default paragraph configuration with standard settings.
    nonisolated(unsafe) public static let `default` = ParagraphConfiguration()
}

/// Text alignment options.
public enum TextAlignment {
    /// Natural alignment based on writing direction.
    case natural
    /// Left-aligned text.
    case left
    /// Right-aligned text.
    case right
    /// Center-aligned text.
    case center
    /// Justified text.
    case justified
}
