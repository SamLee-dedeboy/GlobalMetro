//
//  MetroMap.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
import UIKit

class MetroMap {
    var lines: [MetroLine]
    //var selectedLine: MetroLine?
    var selectedLine = MetroLine("2", UIColor.red)
    init() {
        lines = [MetroLine]()
    }
    init(fromFile filename:String) {
        //TODO: init metroLines from line files
        lines = [MetroLine]()
    }
    func addNewNode(inLine line:MetroLine, naming name: String) {
        
    }
    func addNewLine(lineName: String, color: UIColor) {
        
    }
    func getNodeByName(_ name:String) -> MetroNode? {
        return MetroNode(withName: name, inLine: "2", center: CGPoint(x:0.5,y:0.5))
        
    }
    func save() {
        
    }
    
}
