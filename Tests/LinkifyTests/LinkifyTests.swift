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

import XCTest
import UIKit
@testable import Linkify

@available(iOS 12.0, *)
class LinkifyServiceWithTapDetectionTests: XCTestCase {
    var linkifyService: LinkifyService!
    var label: UILabel!

    override func setUp() {
        super.setUp()
        // Initialize the service and UILabel before each test
        linkifyService = LinkifyService(linkColor: .blue)
        label = UILabel()
    }

    override func tearDown() {
        // Clean up after each test
        linkifyService = nil
        label = nil
        super.tearDown()
    }
    
    /// Test that `formatText` correctly detects and colors links in the text.
    func testLinkDetectionAndFormatting() {
        let text = "Tap here: https://www.example.com"
        let formattedText = linkifyService.formatText(text)
        
        // Check if formatted text contains the links with specified color
        let linkAttributes = [NSAttributedString.Key.foregroundColor: linkifyService.linkColor]
        
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) ?? []
        
        for match in matches {
            if let url = match.url, let range = Range(match.range, in: text) {
                let nsRange = NSRange(range, in: text)
                let attributes = formattedText.attributes(at: nsRange.location, effectiveRange: nil)
                
                // Check that each link has the correct attributes
                XCTAssertEqual(attributes[.foregroundColor] as? UIColor, linkifyService.linkColor, "Link color does not match expected color.")
                XCTAssertEqual(attributes[.link] as? URL, url, "Link URL is not set correctly in the formatted text.")
            }
        }
    }
}
