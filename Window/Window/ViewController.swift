//
//  ViewController.swift
//  Window
//
//  Created by Vein on 2018/10/31.
//  Copyright © 2018 Vein. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    let window: Window = {
        let frame = NSRect(x: 0, y: 0, width: 500, height: 500)
        let style: NSWindow.StyleMask = [.titled, .closable, .resizable, .miniaturizable]
        let w = Window(contentRect: frame, styleMask: style, backing: .buffered, defer: true)
        w.title = "New Create Window"
        //窗口显示
        w.makeKeyAndOrderFront(self)
        
        /* 由于 Window 有历史记忆功能，会记住上次应用运行时退出前的 frame 位置，因此需要先在 xib 界面中 或 通过代码设置 isRestorable 属性为 false */
        
        //        window.isRestorable = false
        
        //窗口居中
        w.center()
        return w
    } ()
    
    let vgView = VGView(frame: NSRect(x: 0, y: 0, width: 50, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        setWindowIcon()
        setWindowColor()
        addButtonToTitleBar()
        view.addSubview(vgView)
        
        // view Frame Bounds 变化发送通知
        vgView.postsFrameChangedNotifications = true
        vgView.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: self, queue: .main) { (notification) in
            print("NSView.frameDidChangeNotification")
        }
        
        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: self, queue: .main) { (notification) in
            print("NSView.boundsDidChangeNotification")
        }
        
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
    
    override func mouseExited(with event: NSEvent) {
        print("mouseExited")
    }
    
    override func mouseEntered(with event: NSEvent) {
        print("mouseEntered")
    }
    
    override func mouseMoved(with event: NSEvent) {
        print("mouseMoved")
    }
    
    override func mouseUp(with event: NSEvent) {
        print("mouseUp")
    }
}

