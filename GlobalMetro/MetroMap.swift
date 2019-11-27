//
//  MetroMap.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
class MetroMap {
    var lines: [MetroLine]
    
    init() {
        lines = [MetroLine]()
    }
    init(fromFile filename:String) {
        //TODO: init metroLines from line files
        lines = [MetroLine]()
    }
    func addNewNode(inLine line:MetroLine, naming name: String) {
        
    }
    func save() {
        
    }
    
}
