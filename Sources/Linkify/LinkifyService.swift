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

// MARK: - LinkifyService
/// A service that detects URLs in a given string and applies link formatting to a UILabel.
@available(iOS 12.0, *)
public class LinkifyService {
    /// The color of the regular text in the label.
    public var textColor: UIColor
    /// The color used to highlight links in the text.
    public var linkColor: UIColor
    
    /// Initializes a new instance of the LinkifyService with specified text and link colors.
    /// - Parameters:
    ///   - textColor: The color for the regular text (default is white).
    ///   - linkColor: The color for the detected links (must be specified).
    public required init(textColor: UIColor = .white, linkColor: UIColor) {
        /// Assigns the provided text color to the textColor property.
        self.textColor = textColor
        /// Assigns the provided link color to the linkColor property.
        self.linkColor = linkColor
    }
    
    /// Formats the given text by applying color attributes for text and links.
    /// - Parameters:
    ///    - text: The string to be formatted as an attributed string.
    ///    - Returns: An NSAttributedString with the appropriate attributes applied.
    public func formatText(_ text: String?) -> NSAttributedString {
        guard let text = text else {
            return (NSMutableAttributedString(string: ""))
        }
        
        let fullRange = NSRange(location: 0, length: text.utf16.count)
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: fullRange)
        
        /// Check for website URLs
        let websiteDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let matches = websiteDetector?.matches(in: text, options: [], range: fullRange) {
            for match in matches {
                if let url = match.url {
                    attributedString.addAttribute(.foregroundColor, value: linkColor, range: match.range)
                    attributedString.addAttribute(.link, value: url, range: match.range)
                }
            }
        }
        
        return (attributedString)
    }
    
    /// Applies link formatting to a UILabel, detecting URLs and setting up a tap gesture recognizer.
    /// - Parameters:
    ///   - label: The UILabel to apply link formatting to.
    ///   - text: The text string that may contain URLs.
    public func apply(to label: UILabel, with text: String) {
        let attributedText = formatText(text)
        label.attributedText = attributedText
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: label, action: #selector(handleLinkTap(_:)))
        label.addGestureRecognizer(tapGesture)
    }
    
    /// Handles tap gestures on the label to detect if a link was tapped.
    /// - Parameter gesture: The gesture recognizer that triggered the action.
    @objc public func handleLinkTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        let text = label.attributedText
        
        /// Get the location of the tap
        let tapLocation = gesture.location(in: label)
        
        /// Create a layout manager to determine which character was tapped
        let textStorage = NSTextStorage(attributedString: text!)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        /// Determine the index of the character tapped
        let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        /// Check if the tapped index corresponds to a link
        text!.enumerateAttribute(.link, in: NSRange(location: 0, length: text!.length), options: []) { (value, range, stop) in
            if NSLocationInRange(characterIndex, range), let url = value as? URL {
                UIApplication.shared.open(url)
            }
        }
    }
}
