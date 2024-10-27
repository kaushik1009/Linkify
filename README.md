# Linkify Framework Documentation

## Overview

**Linkify** is a lightweight Swift framework that simplifies the process of detecting and formatting URLs in UILabels. It allows developers to easily highlight links in text, providing a seamless user experience with tappable URLs.

### Use Case

In applications where textual content is displayed, detecting and making URLs clickable can require extensive code. Linkify reduces this complexity to a single line of code, enabling developers to enhance their UILabels effortlessly.

## Features

- **URL Detection:** Automatically identifies URLs in strings.
- **Customizable Link Colors:** Supports different colors for regular text and detected links.
- **Easy Integration:** Simple API to apply link formatting to UILabels.
- **Tap Detection:** Integrates tap gesture recognizers to handle link taps and navigate to URLs.

## Installation

### Using Swift Package Manager

1. Open your project in Xcode.
2. Navigate to **File > Swift Packages > Add Package Dependency**.
3. Enter the repository URL: `github.com/kaushik1009/Linkify.git`.
4. Follow the prompts to complete the installation.

## Quick Start

### Step 1: Import the Framework

```swift
import Linkify
```

### Step 2: Create an Instance of LinkifyService

```swift
let linkifyService = LinkifyService(linkColor: UIColor.systemBlue)
```

### Step 3: Apply Link Formatting to UILabel

```swift
linkifyService.apply(to: yourLabel, with: "Check it out!! https://www.paypal.com")
```

### Example

Here’s a simple example demonstrating how to use the Linkify framework in a ViewController:

```swift
class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    let linkifyService = LinkifyService(linkColor: .systemBlue)

    override func viewDidLoad() {
        super.viewDidLoad()
        linkifyService.apply(to: label, with: "Visit https://www.apple.com for more information.")
    }
}
```

## Detailed Explanation

### LinkifyService Class

- **Properties:**
  - `textColor`: The color of the regular text in the label.
  - `linkColor`: The color used to highlight links in the text.

- **Methods:**
  - `init(textColor:linkColor:)`: Initializes the LinkifyService with specified colors.
  - `formatText(_:)`: Formats the given string by applying color attributes for text and links.
  - `apply(to:with:)`: Applies link formatting to a UILabel and sets up tap detection.

## Problem Solved

The Linkify framework addresses the common challenge of manually detecting and formatting links in multiple lines of text. Instead of writing complex and repetitive code, developers can achieve link detection and formatting in just one line, improving code readability and maintainability.

## Contribution

Contributions are welcome! Please feel free to open issues, fork the repository, and submit pull requests.

## License

This project is licensed under the MIT License. See the [LICENSE.txt](LICENSE.txt) file for details.
