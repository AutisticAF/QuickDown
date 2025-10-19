# QuickDown

A high-performance Swift library for rendering GitHub-flavored Markdown in SwiftUI applications.

QuickDown provides beautiful, customizable Markdown rendering using CoreText 2 and Apple's swift-markdown library, with support for text selection, search, and programmatic scrolling on both macOS and iOS.

## Features

- **Full GitHub-Flavored Markdown Support**: Renders headings, paragraphs, bold, italic, inline code, code blocks, blockquotes, links, and more
- **High Performance**: Built on CoreText 2 for smooth rendering of long documents
- **Fully Customizable**: Configure fonts, colors, paragraph spacing, and more
- **Cross-Platform**: Works seamlessly on both macOS (14+) and iOS (17+)
- **Text Selection**: Built-in support for selecting and highlighting text ranges
- **Search/Find**: Highlight search terms within the rendered content
- **Smooth Scrolling**: Optimized for scrolling through long markdown documents
- **Programmatic Scrolling**: Scroll to specific text ranges programmatically
- **RTL/LTR Support**: Proper handling of right-to-left and left-to-right text layouts
- **Swift 6.2 Compatible**: Fully supports Swift Concurrency

## Installation

### Swift Package Manager

Add QuickDown to your project using SPM:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/QuickDown.git", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["QuickDown"]
)
```

## Usage

### Basic Usage

```swift
import SwiftUI
import QuickDown

struct ContentView: View {
    let markdown = """
    # Welcome to QuickDown

    This is a **bold** statement and this is *italic*.

    ## Features

    - Fast rendering
    - Customizable
    - Beautiful

    ### Code Example

    ```swift
    let message = "Hello, World!"
    print(message)
    ```

    > This is a blockquote with important information.
    """

    var body: some View {
        QuickDownView(markdown: markdown)
    }
}
```

### Custom Configuration

```swift
import QuickDown

struct CustomizedMarkdownView: View {
    let markdown: String

    var body: some View {
        QuickDownView(
            markdown: markdown,
            configuration: QuickDownConfiguration(
                fontConfiguration: FontConfiguration(
                    body: .systemFont(ofSize: 16),
                    heading1: .boldSystemFont(ofSize: 32),
                    code: .monospacedSystemFont(ofSize: 14, weight: .regular)
                ),
                colorConfiguration: ColorConfiguration(
                    text: .label,
                    heading: .systemBlue,
                    code: .systemPurple,
                    link: .systemTeal
                ),
                paragraphConfiguration: ParagraphConfiguration(
                    lineHeight: 1.5,
                    paragraphSpacing: 16,
                    alignment: .natural
                )
            )
        )
    }
}
```

### Text Search

```swift
struct SearchableMarkdownView: View {
    let markdown: String
    @State private var searchQuery = ""

    var body: some View {
        VStack {
            TextField("Search", text: $searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding()

            QuickDownView(markdown: markdown)
                .search(searchQuery)
        }
    }
}
```

### Programmatic Scrolling

```swift
struct ScrollableMarkdownView: View {
    let markdown: String
    @State private var scrollToRange: TextRange?

    var body: some View {
        VStack {
            Button("Scroll to Position") {
                scrollToRange = TextRange(location: 100, length: 10)
            }

            if let range = scrollToRange {
                QuickDownView(markdown: markdown)
                    .scrollTo(range, animated: true)
            } else {
                QuickDownView(markdown: markdown)
            }
        }
    }
}
```

## Configuration Options

### Font Configuration

Customize fonts for different markdown elements:

```swift
FontConfiguration(
    body: PlatformFont,          // Body text font
    heading1: PlatformFont,       // H1 font
    heading2: PlatformFont,       // H2 font
    heading3: PlatformFont,       // H3 font
    heading4: PlatformFont,       // H4 font
    heading5: PlatformFont,       // H5 font
    heading6: PlatformFont,       // H6 font
    code: PlatformFont,           // Inline code font
    codeBlock: PlatformFont,      // Code block font
    blockquote: PlatformFont      // Blockquote font
)
```

### Color Configuration

Customize colors for different markdown elements:

```swift
ColorConfiguration(
    text: PlatformColor,                    // Body text color
    heading: PlatformColor,                 // Heading color
    code: PlatformColor,                    // Code text color
    codeBlockBackground: PlatformColor,     // Code block background
    blockquoteText: PlatformColor,          // Blockquote text color
    blockquoteBackground: PlatformColor,    // Blockquote background
    link: PlatformColor,                    // Link color
    selection: PlatformColor                // Selection highlight color
)
```

### Paragraph Configuration

Control text layout and spacing:

```swift
ParagraphConfiguration(
    lineHeight: CGFloat,         // Line height multiplier (default: 1.3)
    paragraphSpacing: CGFloat,   // Space between paragraphs (default: 12)
    headingSpacing: CGFloat,     // Space after headings (default: 8)
    alignment: TextAlignment     // Text alignment (.natural, .left, .right, .center, .justified)
)
```

## Architecture

QuickDown is built with a clean, modular architecture:

- **Views**: SwiftUI views for rendering markdown (`QuickDownView`, platform-specific views)
- **Rendering**: CoreText-based rendering engine (`MarkdownRenderer`)
- **Parser**: Markdown parsing using swift-markdown (`MarkdownParser`)
- **Configuration**: Customization options for fonts, colors, and layout
- **Models**: Data models for text ranges and rendered content

## Requirements

- macOS 14.0+ / iOS 17.0+
- Swift 6.2+
- Xcode 16.0+

## Dependencies

- [swift-markdown](https://github.com/apple/swift-markdown) - Apple's official Markdown parser

## Documentation

Full DocC documentation is included with the library. Build documentation in Xcode:

1. Product > Build Documentation
2. Navigate to the QuickDown documentation in the Developer Documentation window

## Performance

QuickDown is optimized for performance:

- CoreText 2 rendering for efficient text layout
- Lazy rendering of large documents
- Smooth scrolling even with thousands of lines
- Minimal memory footprint

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

QuickDown is available under the MIT license. See the LICENSE file for more info.

## Author

Your Name (@yourhandle)

## Acknowledgments

- Built on Apple's [swift-markdown](https://github.com/apple/swift-markdown) library
- Inspired by the need for high-performance markdown rendering in Swift
