//
//  ViewController.swift
//  Mac-WiFi
//
//  Created by Vein on 2018/11/13.
//  Copyright © 2018 Vein. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func wifiOn(_ sender: NSButton) {
        commandLineTask("networksetup -removepreferredwirelessnetwork en1 hardwareport uum-dev-test")
    }
    
    @IBAction func wifiOff(_ sender: NSButton) {
        commandLineTask("networksetup -setairportpower 'Wi-Fi' off")
    }
    
    func commandLineTask(_ command: String) {
        let process = Process()
        process.launchPath = "/bin/sh"
        let arguments = ["-c", command];
        print(arguments)
        process.arguments = arguments
        
        let pipe = Pipe()
        process.standardOutput = pipe
        let file = pipe.fileHandleForReading
        process.launch()
        let data = file.readDataToEndOfFile()
        let string = String(data: data, encoding: .utf8)

        print("got \n" + (string ?? ""))
    }
}

