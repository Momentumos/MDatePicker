//
//  Icons.swift
//  MDatePicker
//
//  Created by Mohammad Yeganeh on 12/23/24.
//


import SwiftUI

struct Icons {
    static let chevronLeft = Image.fromAssets("chevronLeft")
}

#if os(iOS)
extension Image {
    static func fromAssets(_ name: String) -> Image {
        guard let uiImage = UIImage(named: name, in: .module, compatibleWith: nil) else {
            fatalError("Image \(name) not found in Assets.xcassets")
        }
        return Image(uiImage: uiImage)
    }
}
#else
extension Image {
    static func fromAssets(_ name: String) -> Image {
        guard let nsImage = NSImage(named: NSImage.Name(name)) else {
            fatalError("Image \(name) not found in Assets.xcassets")
        }
        return Image(nsImage: nsImage)
    }
}

#endif
