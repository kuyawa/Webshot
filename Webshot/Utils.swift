//
//  Utils.swift
//  Webshot
//
//  Created by Laptop on 7/19/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Cocoa
import Foundation

extension NSImage {
    var png: Data? {
        guard
            let tiffRepresentation = tiffRepresentation,
            let bitmapImage = NSBitmapImageRep(data: tiffRepresentation)
            else { return nil }
        return bitmapImage.representation(using: .PNG, properties: [:])
    }

    var jpg: Data? {
        guard
            let tiffRepresentation = tiffRepresentation,
            let bitmapImage = NSBitmapImageRep(data: tiffRepresentation)
            else { return nil }
        return bitmapImage.representation(using: .JPEG, properties: [:])
    }

    func resize(_ width: CGFloat, _ height: CGFloat) -> NSImage {
        let img = NSImage(size: CGSize(width: width, height: height))
        img.lockFocus()
        let ctx = NSGraphicsContext.current()
        ctx?.imageInterpolation = .high
        let oldRect = NSMakeRect(0, 0, size.width, size.height)
        let newRect = NSMakeRect(0, 0, width, height)
        self.draw(in: newRect, from: oldRect, operation: .copy, fraction: 1)
        img.unlockFocus()
        
        return img
    }
    
    @discardableResult
    func save(_ path: String) -> Bool {
        guard let url = URL(string: path) else { return false }
        
        do {
            try jpg?.write(to: url, options: .atomic)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

extension Date {
    var epoch: Int { return Int(self.timeIntervalSince1970) }
    
    static func epoch(_ time: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(time))
    }
}


// END
