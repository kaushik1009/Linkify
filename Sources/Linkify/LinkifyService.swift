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

/// A service that allows detection of links in a text and enables tapping on links in a UILabel.
@available(iOS 12.0, *)
public struct LinkifyService {
    /// Specifies the color for detected links.
    public var linkColor: UIColor
    
    /// Initializes `LinkifyServiceWithTapDetection` with a specified link color.
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
    
    /// Applies `LinkifyServiceWithTapDetection` to a UILabel, making only link text tappable.
    ///
    /// - Parameters:
    ///   - label: The UILabel to apply link styling.
    ///   - text: The text content to display in the label.
    ///   - linkTappedHandler: A closure to handle taps on detected links.
    public func apply(to label: UILabel, with text: String, linkTappedHandler: @escaping (URL) -> Void) {
        let attributedText = formatText(text)
        label.attributedText = attributedText
        label.isUserInteractionEnabled = true
        
        // Attach custom link tap gesture recognizer
        let tapRecognizer = LinkTapGestureRecognizer(linkTappedHandler: linkTappedHandler)
        label.addGestureRecognizer(tapRecognizer)
    }
}

/// A custom gesture recognizer to detect taps specifically within the link range in a `UILabel`.
class LinkTapGestureRecognizer: UITapGestureRecognizer {
    var linkTappedHandler: ((URL) -> Void)?

    init(linkTappedHandler: @escaping (URL) -> Void) {
        self.linkTappedHandler = linkTappedHandler
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(handleTap(_:)))
    }
    
    /// Method that handles the tap on specific link text areas.
    /// - Parameter gesture: The gesture recognizer that detected the tap.
    @objc public func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText,
              gesture.state == .ended else {
            return
        }
        
        // Get the tapped location within the label
        let tapLocation = gesture.location(in: label)
        
        // Convert location to character index in attributed text
        guard let linkURL = getTappedLink(in: attributedText, at: tapLocation, in: label) else {
            return
        }
        
        // If a link was tapped, execute the handler with the URL
        linkTappedHandler?(linkURL)
    }
    
    /// Determines if the tap location corresponds to a link within the label.
    /// - Parameters:
    ///   - attributedText: The attributed text of the label.
    ///   - location: The location tapped within the label.
    ///   - label: The label view where the tap occurred.
    /// - Returns: The URL if a link was tapped; otherwise, nil.
    private func getTappedLink(in attributedText: NSAttributedString, at location: CGPoint, in label: UILabel) -> URL? {
        // Create a text container and layout manager to measure text layout
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Get the character index at the tapped point
        let tappedIndex = layoutManager.characterIndex(
            for: location,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        // Check if the attributed text at the tapped index contains a link attribute
        let attributes = attributedText.attributes(at: tappedIndex, effectiveRange: nil)
        if let linkURL = attributes[.link] as? URL {
            return linkURL
        }
        
        return nil
    }
}
