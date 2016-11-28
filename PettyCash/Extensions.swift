//
//  Extensions.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/29/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: - Mixed string utils and helpers
extension String {
    
    
    /**
     Encode a String to Base64
     
     :returns:
     */
    public func toBase64()->String{
        
        let data = self.data(using: String.Encoding.utf8)
        
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
    }
    
}


extension Date {
    public static func tomorrow() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    public static func days(away days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())!
    }
    
    public static func weeks(away weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: weeks * 7, to: Date())!
    }
    
    public func formattedDate(_ dateStyle: DateFormatter.Style, time timeStyle: DateFormatter.Style = .none) -> String {
        return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }
}

extension Double {
    
    var formattedCurrency : String {
        
        let number = NSNumber(value: self)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        
        return formatter.string(from: number)!
        
    }
    
}

public enum GradientDirection {
    case Up
    case Left
    case UpLeft
    case UpRight
}

public extension SKTexture {
    
    convenience init(size: CGSize, color1: CIColor, color2: CIColor, direction: GradientDirection = .Up) {
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        var startVector: CIVector
        var endVector: CIVector
        
        filter!.setDefaults()
        
        switch direction {
        case .Up:
            startVector = CIVector(x: size.width * 0.5, y: 0)
            endVector = CIVector(x: size.width * 0.5, y: size.height)
        case .Left:
            startVector = CIVector(x: size.width, y: size.height * 0.5)
            endVector = CIVector(x: 0, y: size.height * 0.5)
        case .UpLeft:
            startVector = CIVector(x: size.width, y: 0)
            endVector = CIVector(x: 0, y: size.height)
        case .UpRight:
            startVector = CIVector(x: 0, y: 0)
            endVector = CIVector(x: size.width, y: size.height)
        }
        
        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(color1, forKey: "inputColor0")
        filter!.setValue(color2, forKey: "inputColor1")
        
        let image = context.createCGImage(filter!.outputImage!, from: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.init(cgImage: image!)
    }
    
}




















