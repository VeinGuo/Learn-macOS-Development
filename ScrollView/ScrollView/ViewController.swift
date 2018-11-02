//
//  ViewController.swift
//  ScrollView
//
//  Created by Vein on 2018/11/2.
//  Copyright © 2018 Vein. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let scrollView: NSScrollView = {
      let s = NSScrollView()
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        let image = NSImage(named: "macbook-air-image")!;
        let imageView = NSImageView(image: image)
        imageView.frame = scrollView.bounds
        imageView.setFrameSize(image.size)
        scrollView.documentView = imageView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        
        let letfConstraint = NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        let rightConstrain = NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        let topConstrain = NSLayoutConstraint(item: scrollView, attribute: .top
            , relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConstrain = NSLayoutConstraint(item: scrollView, attribute: .bottom
            , relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([letfConstraint, rightConstrain, topConstrain, bottomConstrain])
    }

    override var representedObject: Any? {
        didSet {
        
        }
    }


}

