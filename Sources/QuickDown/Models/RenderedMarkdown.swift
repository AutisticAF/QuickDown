import CoreText
import Foundation

/// Represents rendered markdown content ready for display.
///
/// `RenderedMarkdown` contains the attributed string and layout information
/// for rendered markdown content.
///
/// ## Topics
/// ### Creating Rendered Markdown
/// - ``init(attributedString:framesetters:totalHeight:)``
///
/// ### Content Properties
/// - ``attributedString``
/// - ``framesetters``
/// - ``totalHeight``
public struct RenderedMarkdown {
    /// The attributed string containing the formatted markdown content.
    public let attributedString: NSAttributedString

    /// CoreText framesetters for laying out the content.
    ///
    /// Multiple framesetters may be used for complex layouts.
    public let framesetters: [CTFramesetter]

    /// The total height required to display all content.
    public let totalHeight: CGFloat

    /// Creates a new rendered markdown instance.
    ///
    /// - Parameters:
    ///   - attributedString: The formatted markdown content.
    ///   - framesetters: CoreText framesetters for layout.
    ///   - totalHeight: The total height required for display.
    public init(
        attributedString: NSAttributedString,
        framesetters: [CTFramesetter],
        totalHeight: CGFloat
    ) {
        self.attributedString = attributedString
        self.framesetters = framesetters
        self.totalHeight = totalHeight
    }
}
