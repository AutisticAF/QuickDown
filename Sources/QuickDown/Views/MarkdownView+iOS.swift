#if os(iOS)
import SwiftUI
import UIKit

/// iOS-specific implementation of the markdown view.
///
/// This view uses UITextView with CoreText for high-performance rendering.
struct MarkdownView: UIViewRepresentable {
    let markdown: String
    let configuration: QuickDownConfiguration
    @Binding var selectedRange: TextRange?
    @Binding var scrollTarget: TextRange?
    @Binding var searchQuery: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        // Configure text view
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.delegate = context.coordinator

        // Configure text container
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.widthTracksTextView = true

        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        // Render markdown
        let renderer = MarkdownRenderer(configuration: configuration)
        let rendered = renderer.render(markdown)

        // Update text storage
        textView.attributedText = rendered.attributedString

        // Apply search highlighting
        if !searchQuery.isEmpty {
            applySearchHighlighting(to: textView, query: searchQuery)
        }

        // Handle selection
        if let range = selectedRange {
            textView.selectedRange = range.nsRange
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

    private func applySearchHighlighting(to textView: UITextView, query: String) {
        guard let textStorage = textView.textStorage else { return }
        let text = textStorage.string

        // Create a mutable copy
        let mutableAttributedString = NSMutableAttributedString(attributedString: textStorage)

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
            mutableAttributedString.addAttribute(
                .backgroundColor,
                value: UIColor.systemYellow.withAlphaComponent(0.3),
                range: foundRange
            )

            // Move to next possible match
            searchRange.location = foundRange.location + foundRange.length
            searchRange.length = text.utf16.count - searchRange.location
        }

        textView.attributedText = mutableAttributedString
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var selectedRange: TextRange?

        init(selectedRange: Binding<TextRange?>) {
            self._selectedRange = selectedRange
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            let range = textView.selectedRange

            if range.length > 0 {
                selectedRange = TextRange(range)
            } else {
                selectedRange = nil
            }
        }
    }
}
#endif
