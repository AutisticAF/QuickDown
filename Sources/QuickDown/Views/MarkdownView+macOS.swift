#if os(macOS)
import SwiftUI
import AppKit

/// macOS-specific implementation of the markdown view.
///
/// This view uses NSTextView with CoreText for high-performance rendering.
struct MarkdownView: NSViewRepresentable {
    let markdown: String
    let configuration: QuickDownConfiguration
    @Binding var selectedRange: TextRange?
    @Binding var scrollTarget: TextRange?
    @Binding var searchQuery: String

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        let textView = scrollView.documentView as! NSTextView

        // Configure text view
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.drawsBackground = false
        textView.textContainerInset = NSSize(width: 8, height: 8)
        textView.delegate = context.coordinator

        // Configure text container
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainer?.widthTracksTextView = true

        // Enable smooth scrolling
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true

        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }

        // Render markdown
        let renderer = MarkdownRenderer(configuration: configuration)
        let rendered = renderer.render(markdown)

        // Update text storage
        textView.textStorage?.setAttributedString(rendered.attributedString)

        // Apply search highlighting
        if !searchQuery.isEmpty {
            applySearchHighlighting(to: textView, query: searchQuery)
        }

        // Handle selection
        if let range = selectedRange {
            textView.setSelectedRange(range.nsRange)
        }

        // Handle scroll target
        if let target = scrollTarget {
            textView.scrollRangeToVisible(target.nsRange)
            DispatchQueue.main.async {
                scrollTarget = nil
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedRange: $selectedRange)
    }

    private func applySearchHighlighting(to textView: NSTextView, query: String) {
        guard let textStorage = textView.textStorage else { return }
        let text = textStorage.string

        // Find all occurrences
        var searchRange = NSRange(location: 0, length: text.utf16.count)
        while searchRange.location < text.utf16.count {
            let foundRange = (text as NSString).range(
                of: query,
                options: [.caseInsensitive],
                range: searchRange
            )

            if foundRange.location == NSNotFound {
                break
            }

            // Highlight the match
            textStorage.addAttribute(
                .backgroundColor,
                value: NSColor.systemYellow.withAlphaComponent(0.3),
                range: foundRange
            )

            // Move to next possible match
            searchRange.location = foundRange.location + foundRange.length
            searchRange.length = text.utf16.count - searchRange.location
        }
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        @Binding var selectedRange: TextRange?

        init(selectedRange: Binding<TextRange?>) {
            self._selectedRange = selectedRange
        }

        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            let range = textView.selectedRange()

            if range.length > 0 {
                selectedRange = TextRange(range)
            } else {
                selectedRange = nil
            }
        }
    }
}
#endif
