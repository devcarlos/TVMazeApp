//
//  String+Utils.swift
//  TVMazeApp
//
//  Created by Carlos Alcala on 7/26/19.
//  Copyright © 2019 Carlos Alcala. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var HTMLToAttributedText: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let string:NSMutableAttributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            
            var multipleAttributes = [NSAttributedString.Key : Any]()
            multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.darkGray
            multipleAttributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
            multipleAttributes[NSAttributedString.Key.font] = UIFont(name: "Helvetica", size: 15.0)!
            
            let range = NSRange(location: 0, length: string.length)
            string.addAttributes(multipleAttributes, range: range)
            
            return string
        } catch {
            return NSAttributedString()
        }
    }
    
    var HTMLToString: String {
        return HTMLToAttributedText?.string ?? ""
    }
}
