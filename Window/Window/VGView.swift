//
//  VGView.swift
//  Window
//
//  Created by Vein on 2018/11/2.
//  Copyright © 2018 Vein. All rights reserved.
//

import Cocoa

class VGView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        /*
         “视图本身没有提供背景，边框，圆角等属性，可以利用layer属性来控制这些效果，使用层属性之前必须调用设置wantsLayer为YES。”
         摘录来自: @剑指人心. “MacDev。” Apple Books.
         */
        wantsLayer = true
        layer?.backgroundColor = NSColor.yellow.cgColor
        layer?.borderColor = NSColor.blue.cgColor
        layer?.borderWidth = 2
        layer?.cornerRadius = 8
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.brown.setFill()
        let rounded = NSBezierPath(roundedRect: bounds, xRadius: 20, yRadius: 20)
        rounded.fill()
    }
    
}
