import Foundation

/// Represents a range of text within the markdown content.
///
/// `TextRange` is used for text selection, highlighting, and programmatic scrolling.
///
/// ## Topics
/// ### Creating Text Ranges
/// - ``init(location:length:)``
/// - ``init(_:)``
///
/// ### Range Properties
/// - ``location``
/// - ``length``
/// - ``nsRange``
public struct TextRange: Equatable {
    /// The starting position of the range.
    public let location: Int

    /// The length of the range.
    public let length: Int

    /// Creates a text range with the specified location and length.
    ///
    /// - Parameters:
    ///   - location: The starting position of the range.
    ///   - length: The length of the range.
    public init(location: Int, length: Int) {
        self.location = location
        self.length = length
    }

    /// Creates a text range from an NSRange.
    ///
    /// - Parameter nsRange: The NSRange to convert.
    public init(_ nsRange: NSRange) {
        self.location = nsRange.location
        self.length = nsRange.length
    }

    /// Converts this text range to an NSRange.
    public var nsRange: NSRange {
        NSRange(location: location, length: length)
    }

    /// The end position of the range.
    public var end: Int {
        location + length
    }

    /// Checks if this range contains the specified location.
    ///
    /// - Parameter position: The position to check.
    /// - Returns: `true` if the range contains the position, `false` otherwise.
    public func contains(_ position: Int) -> Bool {
        position >= location && position < end
    }

    /// Checks if this range intersects with another range.
    ///
    /// - Parameter other: The other range to check.
    /// - Returns: `true` if the ranges intersect, `false` otherwise.
    public func intersects(_ other: TextRange) -> Bool {
        location < other.end && other.location < end
    }
}
