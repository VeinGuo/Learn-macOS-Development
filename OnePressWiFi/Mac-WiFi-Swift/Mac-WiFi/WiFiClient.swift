//
//  WiFiClient.swift
//  Mac-WiFi
//
//  Created by Vein on 2018/11/13.
//  Copyright © 2018 Vein. All rights reserved.
//

import Cocoa

public enum WiFiClientState {
    case idle
    case block
    case connecting
    case connected
}

public protocol WiFiClientDelegate: class {

}

class WiFiClient: NSObject {
    
}
