//
//  ViewController.swift
//  Window
//
//  Created by Vein on 2018/10/31.
//  Copyright © 2018 Vein. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let window: NSWindow = {
        let frame = NSRect(x: 0, y: 0, width: 500, height: 500)
        let style: NSWindow.StyleMask = [.titled, .closable, .resizable, .miniaturizable]
        let window = NSWindow(contentRect: frame, styleMask: style, backing: .buffered, defer: true)
        window.title = "New Create Window"
        //窗口显示
        window.makeKeyAndOrderFront(self)
        //        window.isRestorable = false
        //窗口居中
        window.center()
        return window
    } ()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setWindowIcon()
        setWindowColor()
        addButtonToTitleBar()
    }

    func setWindowIcon() -> Void {
        window.representedURL = URL(string: "WindowTitle")
        window.title = "SQLiteApp"
        let image = NSImage(named: "buttonKey")
        window.standardWindowButton(.documentIconButton)?.image = image
    }
    
    func setWindowColor() -> Void {
        window.isOpaque = false
        window.backgroundColor = .white
    }
    
    func addButtonToTitleBar() -> Void {
        let titleView = window.standardWindowButton(.closeButton)?.superview
        let button = NSButton()
        button.title = "Register"
        let x = (window.contentView?.frame.width ?? 0) - 200
        button.frame = NSMakeRect(x, 0, 80, 24)
        button.bezelStyle = .rounded
        titleView?.addSubview(button)
    }
    
    
}

