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
    var mapInfo = [String:[MetroNode]]()
    //var selectedLine: MetroLine?
    init() {
        lines = [MetroLine]()
    }
    init(fromFile filename:String) {
        //TODO: init metroLines from line files
        lines = [MetroLine]()
    }
    func addNewNode(inLine lineName:String, naming nodeName: String) {
        print("adding node in line: \(lineName)")
        var node = MetroNode(withName: nodeName, inLine: lineName, center: CGPoint(x:0.5,y:0.5))
        for line in lines {
            if line.lineName == lineName {
                line.stations.append(node);
                print("added node: \(nodeName)")

            }
        }
    }
    func addNewLine(lineName: String, color: UIColor) {
        lines.append(MetroLine(lineName, color))
        print("added line")
        printLines()
    }
    func getNodeByName(_ name:String) -> MetroNode? {
        printLines()
        
        for line in lines {
            for node in line.stations {
                if node.stationName == name {
                    return node
                }
            }
        }
        return nil
        
        //return MetroNode(withName: name, inLine: "2", center: CGPoint(x:0.5,y:0.5))
        
    }
    func printLines() {
        for line in lines {
            print("line: \(line.lineName)")
            for node in line.stations {
                print(node.name, " ", node.metroLine, " \n")
            }
        }
    }
    func save() {
        
    }
    
}
