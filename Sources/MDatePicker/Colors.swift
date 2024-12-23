//
//  Colors.swift
//  MDatePicker
//
//  Created by Mohammad Yeganeh on 12/23/24.
//
import SwiftUI

struct Colors {
    
    struct accent {
        static let info = Color.fromAssets("colorAccentInfo")
    }
    
    struct background {
        static let main = Color.fromAssets("colorBackgroundDefault")
        static let info = Color.fromAssets("colorBackgroundInfo")
        static let disabled = Color.fromAssets("colorBackgroundDisabled")
        static let secondary = Color.fromAssets("colorBackgroundSecondary")
    }
    
    struct border {
        static let main = Color.fromAssets("colorBorderDefault")
    }
    
    struct content {
        static let alternative = Color.fromAssets("colorContentAlternative")
        static let main = Color.fromAssets("colorContentDefault")
        static let inactive = Color.fromAssets("colorContentInactive")
        static let secondary = Color.fromAssets("colorContentSecondary")
    }
    
}

#if os(iOS)
extension Color {
    static func fromAssets(_ name: String) -> Color {
        guard let uiColor = UIColor(named: name, in: .module, compatibleWith: nil) else {
            fatalError("Color \(name) not found in Assets.xcassets")
        }
        return Color(uiColor)
    }
}
#else
extension Color {
    static func fromAssets(_ name: String) -> Color {
        guard let nsColor = NSColor(named: name, bundle: .module) else {
            fatalError("Color \(name) not found in Assets.xcassets")
        }
        return Color(nsColor)
    }
}
#endif
