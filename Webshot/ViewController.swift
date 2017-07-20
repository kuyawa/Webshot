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
    
    @IBOutlet weak var textUrl    : NSTextField!
    @IBOutlet weak var buttonGo   : NSButton!
    @IBOutlet weak var buttonShot : NSButton!
    @IBOutlet weak var webView    : WebView!

    @IBAction func onNavigate(_ sender: Any) {
        buttonShot.isEnabled = false
        let address = textUrl.stringValue
        let url = URL(string: address)!
        let req = URLRequest(url: url)
        webView.mainFrame.load(req)
    }

    @IBAction func onWebshot(_ sender: Any) {
        takeWebshot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frameLoadDelegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        textUrl.stringValue = "http://example.com"
        buttonShot.isEnabled = false
    }

    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        buttonShot.isEnabled = true
    }
    
    func takeWebshot() {
        let folder = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let url =  folder.appendingPathComponent("screenshot\(Date().epoch).jpg")
        let image = webView.webshot()
        
        do {
            try image.jpg?.write(to: url)
            NSWorkspace.shared().open(url)   // show in preview
        }
        catch { print("Error: ", error) }
    }
    
}


// END
