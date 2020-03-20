//
//  Helpers.swift
//  marvel-ios-test
//
//  Created by Zachary Esmaelzada on 3/19/20.
//  Copyright © 2020 Zachary Esmaelzada. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

let COLOR_BACKGROUND_BLACK = UIColor(netHex: 0x272727)
let COLOR_PURPLE = UIColor(netHex: 0x663E9D)

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIFont {
    static func customFont(size: Int) -> UIFont {
        let fontSize = CGFloat(size)
        let font = UIFont(name: "AvenirNext-Regular", size: fontSize)
        return font ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    static func customFontBold(size: Int) -> UIFont {
        let fontSize = CGFloat(size)
        let font = UIFont(name: "AvenirNext-Bold", size: fontSize)
        return font ?? UIFont.systemFont(ofSize: fontSize)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
