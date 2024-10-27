// Copyright 2024 Kaushik J
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import UIKit

@available(iOS 12.0, *)
public class LinkifyService {
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap(_:)))
        label.addGestureRecognizer(tapGesture)
    }
    
    /// Handles link tap for UILabel
    ///
    /// - Parameters:
    ///   - gesture: The gesture recognizer to detect touches
    @objc func handleLinkTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel, let text = label.attributedText else { return }
        
        let tapLocation = gesture.location(in: label)
        let textStorage = NSTextStorage(attributedString: text)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        text.enumerateAttribute(.link, in: NSRange(location: 0, length: text.length), options: []) { (value, range, stop) in
            if NSLocationInRange(characterIndex, range), let url = value as? URL {
                UIApplication.shared.open(url)
            }
        }
    }
}
