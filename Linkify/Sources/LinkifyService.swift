//
//  LinkifyService.swift
//  Linkify
//
//  Created by kaushik on 27/10/24.
//

import Foundation
import UIKit

@available(iOS 12.0, *)
public struct LinkifyService {
    /// Specifies the color for detected links.
    public var linkColor: UIColor
    
    /// Initializes `LinkifyService` with a specified link color.
    ///
    /// - Parameter linkColor: The color to use for detected links.
    public init(linkColor: UIColor = .blue) {
        self.linkColor = linkColor
    }

    /// Formats a given string, detecting URLs and applying tappable attributes.
    ///
    /// - Parameter text: The input string to format.
    /// - Returns: An attributed string with detected URLs styled.
    public func formatText(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) ?? []
        
        for match in matches {
            if let range = Range(match.range, in: text) {
                attributedString.addAttribute(.foregroundColor, value: linkColor, range: NSRange(range, in: text))
                attributedString.addAttribute(.link, value: match.url!, range: NSRange(range, in: text))
            }
        }
        
        return attributedString
    }

    #if DEBUG
    /// Prints a debug message of the attributed text details.
    ///
    /// - Parameter attributedString: The attributed string to inspect.
    public func debugAttributedString(_ attributedString: NSAttributedString) {
        print("Formatted text with links: \(attributedString.string)")
    }
    #endif
}

// MARK: - Example Usage

@available(iOS 12.0, *)
public extension LinkifyService {
    /// Applies `LinkifyService` to a UILabel, making it tappable for links.
    ///
    /// - Parameters:
    ///   - label: The UILabel to apply link styling.
    ///   - text: The text content to display in the label.
    func apply(to label: UILabel, with text: String) {
        let attributedText = formatText(text)
        label.attributedText = attributedText
        label.isUserInteractionEnabled = true
    }
}
