import CoreText
import Foundation
import Markdown

/// Renders markdown text into attributed strings using CoreText.
///
/// `MarkdownRenderer` converts markdown text into a formatted
/// attributed string with proper styling based on the configuration.
///
/// ## Topics
/// ### Creating a Renderer
/// - ``init(configuration:)``
///
/// ### Rendering Markdown
/// - ``render(_:)``
final class MarkdownRenderer {
    private let configuration: QuickDownConfiguration

    /// Creates a new markdown renderer with the specified configuration.
    ///
    /// - Parameter configuration: The configuration for styling the rendered content.
    init(configuration: QuickDownConfiguration = .default) {
        self.configuration = configuration
    }

    /// Renders markdown text into a rendered markdown structure.
    ///
    /// - Parameter text: The markdown text to render.
    /// - Returns: A `RenderedMarkdown` instance ready for display.
    func render(_ text: String) -> RenderedMarkdown {
        let document = Document(parsing: text)
        let attributedString = buildAttributedString(from: document)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)

        // Calculate total height needed
        let constraints = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRange(location: 0, length: 0),
            nil,
            constraints,
            nil
        )

        return RenderedMarkdown(
            attributedString: attributedString,
            framesetters: [framesetter],
            totalHeight: size.height
        )
    }

    // MARK: - Private Methods

    private func buildAttributedString(from document: Document) -> NSAttributedString {
        var visitor = AttributedStringVisitor(configuration: configuration)
        let result = visitor.visit(document)
        return result
    }
}

// MARK: - Attributed String Visitor

/// Internal visitor that walks the markdown document tree and builds an attributed string.
private struct AttributedStringVisitor: MarkupVisitor {
    typealias Result = NSMutableAttributedString

    private let configuration: QuickDownConfiguration
    private var currentAttributes: [NSAttributedString.Key: Any] = [:]

    init(configuration: QuickDownConfiguration) {
        self.configuration = configuration
        self.currentAttributes = baseAttributes()
    }

    mutating func defaultVisit(_ markup: any Markup) -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        for child in markup.children {
            result.append(visit(child))
        }
        return result
    }

    mutating func visitDocument(_ document: Document) -> NSMutableAttributedString {
        defaultVisit(document)
    }

    mutating func visitParagraph(_ paragraph: Paragraph) -> NSMutableAttributedString {
        let result = defaultVisit(paragraph)
        result.append(NSAttributedString(
            string: "\n",
            attributes: paragraphAttributes()
        ))
        return result
    }

    mutating func visitHeading(_ heading: Heading) -> NSMutableAttributedString {
        let oldAttributes = currentAttributes
        currentAttributes = headingAttributes(level: heading.level)
        let result = defaultVisit(heading)
        result.append(NSAttributedString(
            string: "\n",
            attributes: headingParagraphAttributes()
        ))
        currentAttributes = oldAttributes
        return result
    }

    mutating func visitText(_ text: Markdown.Text) -> NSMutableAttributedString {
        NSMutableAttributedString(
            string: text.string,
            attributes: currentAttributes
        )
    }

    mutating func visitStrong(_ strong: Strong) -> NSMutableAttributedString {
        let oldAttributes = currentAttributes
        currentAttributes = boldAttributes(from: currentAttributes)
        let result = defaultVisit(strong)
        currentAttributes = oldAttributes
        return result
    }

    mutating func visitEmphasis(_ emphasis: Emphasis) -> NSMutableAttributedString {
        let oldAttributes = currentAttributes
        currentAttributes = italicAttributes(from: currentAttributes)
        let result = defaultVisit(emphasis)
        currentAttributes = oldAttributes
        return result
    }

    mutating func visitInlineCode(_ inlineCode: InlineCode) -> NSMutableAttributedString {
        NSMutableAttributedString(
            string: inlineCode.code,
            attributes: codeAttributes()
        )
    }

    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(
            string: codeBlock.code + "\n",
            attributes: codeBlockAttributes()
        )
        return result
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> NSMutableAttributedString {
        let oldAttributes = currentAttributes
        currentAttributes = blockquoteAttributes()
        let result = defaultVisit(blockQuote)
        currentAttributes = oldAttributes
        return result
    }

    mutating func visitLink(_ link: Markdown.Link) -> NSMutableAttributedString {
        let oldAttributes = currentAttributes
        currentAttributes = linkAttributes(url: link.destination)
        let result = defaultVisit(link)
        currentAttributes = oldAttributes
        return result
    }

    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        for child in unorderedList.children {
            result.append(visit(child))
        }
        return result
    }

    mutating func visitOrderedList(_ orderedList: OrderedList) -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        var itemNumber = Int(orderedList.startIndex)
        for child in orderedList.children {
            if let listItem = child as? ListItem {
                let itemResult = visitListItem(listItem, number: itemNumber, isOrdered: true)
                result.append(itemResult)
                itemNumber += 1
            } else {
                result.append(visit(child))
            }
        }
        return result
    }

    mutating func visitListItem(_ listItem: ListItem) -> NSMutableAttributedString {
        visitListItem(listItem, number: nil, isOrdered: false)
    }

    private mutating func visitListItem(_ listItem: ListItem, number: Int?, isOrdered: Bool) -> NSMutableAttributedString {
        let result = NSMutableAttributedString()

        // Add list marker with indentation
        let marker = isOrdered ? "\(number ?? 1). " : "• "
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 20
        paragraphStyle.lineHeightMultiple = configuration.paragraphConfiguration.lineHeight
        paragraphStyle.alignment = nsTextAlignment(from: configuration.paragraphConfiguration.alignment)

        var markerAttributes = currentAttributes
        markerAttributes[.paragraphStyle] = paragraphStyle

        result.append(NSAttributedString(string: marker, attributes: markerAttributes))

        // Add list item content
        for child in listItem.children {
            result.append(visit(child))
        }

        // Add newline after list item
        result.append(NSAttributedString(string: "\n", attributes: markerAttributes))

        return result
    }

    // MARK: - Attribute Builders

    private func baseAttributes() -> [NSAttributedString.Key: Any] {
        let font = configuration.fontConfiguration.body
        let color = configuration.colorConfiguration.text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = configuration.paragraphConfiguration.lineHeight
        paragraphStyle.alignment = nsTextAlignment(from: configuration.paragraphConfiguration.alignment)

        return [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
    }

    private func headingAttributes(level: Int) -> [NSAttributedString.Key: Any] {
        let font: PlatformFont
        switch level {
        case 1: font = configuration.fontConfiguration.heading1
        case 2: font = configuration.fontConfiguration.heading2
        case 3: font = configuration.fontConfiguration.heading3
        case 4: font = configuration.fontConfiguration.heading4
        case 5: font = configuration.fontConfiguration.heading5
        default: font = configuration.fontConfiguration.heading6
        }

        return [
            .font: font,
            .foregroundColor: configuration.colorConfiguration.heading
        ]
    }

    private func codeAttributes() -> [NSAttributedString.Key: Any] {
        [
            .font: configuration.fontConfiguration.code,
            .foregroundColor: configuration.colorConfiguration.code
        ]
    }

    private func codeBlockAttributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = configuration.paragraphConfiguration.paragraphSpacing

        return [
            .font: configuration.fontConfiguration.codeBlock,
            .foregroundColor: configuration.colorConfiguration.code,
            .backgroundColor: configuration.colorConfiguration.codeBlockBackground,
            .paragraphStyle: paragraphStyle
        ]
    }

    private func blockquoteAttributes() -> [NSAttributedString.Key: Any] {
        [
            .font: configuration.fontConfiguration.blockquote,
            .foregroundColor: configuration.colorConfiguration.blockquoteText,
            .backgroundColor: configuration.colorConfiguration.blockquoteBackground
        ]
    }

    private func linkAttributes(url: String?) -> [NSAttributedString.Key: Any] {
        var attrs = currentAttributes
        attrs[.foregroundColor] = configuration.colorConfiguration.link
        if let url = url, let nsURL = URL(string: url) {
            attrs[.link] = nsURL
        }
        return attrs
    }

    private func paragraphAttributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = configuration.paragraphConfiguration.paragraphSpacing
        paragraphStyle.lineHeightMultiple = configuration.paragraphConfiguration.lineHeight
        paragraphStyle.alignment = nsTextAlignment(from: configuration.paragraphConfiguration.alignment)

        return [
            .paragraphStyle: paragraphStyle
        ]
    }

    private func headingParagraphAttributes() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = configuration.paragraphConfiguration.headingSpacing

        return [
            .paragraphStyle: paragraphStyle
        ]
    }

    private func boldAttributes(from attrs: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var newAttrs = attrs
        if let currentFont = attrs[.font] as? PlatformFont {
            #if os(macOS)
            let boldFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .boldFontMask)
            #else
            let boldFont = UIFont(descriptor: currentFont.fontDescriptor.withSymbolicTraits(.traitBold) ?? currentFont.fontDescriptor, size: currentFont.pointSize)
            #endif
            newAttrs[.font] = boldFont
        }
        return newAttrs
    }

    private func italicAttributes(from attrs: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var newAttrs = attrs
        if let currentFont = attrs[.font] as? PlatformFont {
            #if os(macOS)
            let italicFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .italicFontMask)
            #else
            let italicFont = UIFont(descriptor: currentFont.fontDescriptor.withSymbolicTraits(.traitItalic) ?? currentFont.fontDescriptor, size: currentFont.pointSize)
            #endif
            newAttrs[.font] = italicFont
        }
        return newAttrs
    }

    private func nsTextAlignment(from alignment: TextAlignment) -> NSTextAlignment {
        switch alignment {
        case .natural: return .natural
        case .left: return .left
        case .right: return .right
        case .center: return .center
        case .justified: return .justified
        }
    }
}
