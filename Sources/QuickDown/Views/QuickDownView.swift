@_exported import SwiftUI

/// A SwiftUI view that renders GitHub-flavored Markdown with rich formatting.
///
/// `QuickDownView` provides a high-performance markdown rendering view built on CoreText.
/// It supports text selection, searching, programmatic scrolling, and full customization.
///
/// ## Topics
/// ### Creating a QuickDown View
/// - ``init(markdown:configuration:)``
///
/// ### View Modifiers
/// - ``scrollTo(_:animated:)``
/// - ``search(_:)``
///
/// ## Example
/// ```swift
/// QuickDownView(markdown: "# Hello World\n\nThis is **bold** and *italic* text.")
/// ```
public struct QuickDownView: View {
    private let markdown: String
    private let configuration: QuickDownConfiguration

    @State private var selectedRange: TextRange?
    @State private var scrollTarget: TextRange?
    @State private var searchQuery: String = ""

    /// Creates a new QuickDown view.
    ///
    /// - Parameters:
    ///   - markdown: The markdown text to render.
    ///   - configuration: The configuration for styling. Defaults to `.default`.
    public init(
        markdown: String,
        configuration: QuickDownConfiguration = .default
    ) {
        self.markdown = markdown
        self.configuration = configuration
    }

    public var body: some View {
        MarkdownView(
            markdown: markdown,
            configuration: configuration,
            selectedRange: $selectedRange,
            scrollTarget: $scrollTarget,
            searchQuery: $searchQuery
        )
    }

    /// Scrolls to the specified text range.
    ///
    /// - Parameters:
    ///   - range: The text range to scroll to.
    ///   - animated: Whether to animate the scroll. Defaults to `true`.
    public func scrollTo(_ range: TextRange, animated: Bool = true) -> Self {
        var modified = self
        modified.scrollTarget = range
        return modified
    }

    /// Sets the search query to highlight matching text.
    ///
    /// - Parameter query: The text to search for.
    public func search(_ query: String) -> Self {
        var modified = self
        modified.searchQuery = query
        return modified
    }
}
