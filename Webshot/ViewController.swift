//
//  ViewController.swift
//  Webshot
//
//  Created by Laptop on 7/19/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WebFrameLoadDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var oldView: WebView!

    @IBAction func onNavigate(_ sender: Any) {
        let wc = self.view.window?.windowController as! WindowController
        wc.buttonShot.isEnabled = false
        let address = wc.textUrl.stringValue
        let url = URL(string: address)!
        let req = URLRequest(url: url)
        oldView.mainFrame.load(req)
    }

    @IBAction func onWebshot(_ sender: Any) {
        takeWebshot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldView.frameLoadDelegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        let wc = self.view.window?.windowController as! WindowController
        wc.textUrl.stringValue = "http://example.com"
        wc.buttonShot.isEnabled = false
    }

    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        let wc = self.view.window?.windowController as! WindowController
        wc.buttonShot.isEnabled = true
    }
    
    func takeWebshot() {
        let folder = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let url =  folder.appendingPathComponent("screenshot\(Date().epoch).jpg")
        print("Write to ", url)
        let image = oldView.webshot()
        do {
            try image.jpg?.write(to: url)
            // show in preview
            NSWorkspace.shared().open(url)
        }
        catch { print("Error: ", error) }
    }
}

extension WebView {
    func webshot() -> NSImage {
        let doc  = self.mainFrame.frameView.documentView!
        let rect = doc.bounds
        let size = NSSize(width: rect.width, height: rect.height)
        //Swift.print("Size: ", size)
        let bitmap = doc.bitmapImageRepForCachingDisplay(in: rect)!
        doc.cacheDisplay(in: rect, to: bitmap)
        return NSImage(cgImage: bitmap.cgImage!, size: size)
    }
}


// END
