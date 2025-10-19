import Foundation
import Markdown

/// Parser for converting markdown text into a structured document tree.
///
/// `MarkdownParser` uses Apple's swift-markdown library to parse
/// GitHub-flavored Markdown into a document structure.
///
/// ## Topics
/// ### Parsing Markdown
/// - ``parse(_:)``
struct MarkdownParser {
    /// Creates a new markdown parser.
    init() {}

    /// Parses markdown text into a document structure.
    ///
    /// - Parameter text: The markdown text to parse.
    /// - Returns: A parsed markdown document.
    func parse(_ text: String) -> Document {
        Document(parsing: text)
    }
}
