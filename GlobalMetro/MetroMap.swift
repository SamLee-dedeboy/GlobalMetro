//
//  MetroMap.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
import UIKit

class MetroMap: Codable {
    var mapName:String
    var lines: [MetroLine]
    //var mapInfo = [String:[MetroNode]]()
    //var selectedLine: MetroLine?
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(MetroMap.self, from:json) {
            self.mapName = newValue.mapName
            self.lines = newValue.lines
            //self.mapInfo = newValue.mapInfo
        } else {
            return nil
        }
    }
    var json:Data? {
        return try? JSONEncoder().encode(self)
    }
    init() {
        mapName = "DefaultMapName"
        lines = [MetroLine]()
    }
    init(fromFile filename:String) {
        //TODO: init metroLines from line files
        mapName = filename
        lines = [MetroLine]()
    }
    func addNewNode(inLines lineList:[String], naming nodeName: String) {
        print("adding node in line: \(lineList)")
        var node = MetroNode(withName: nodeName, center: CGPoint.zero)
        for lineName in lineList {
            if let line = self.getLineByName(lineName) {
                if let lastNode = line.stations.last {
                    lastNode.adjacentNodes.append(node.stationName)
                    node.adjacentNodes.append(lastNode.stationName)
                }
                line.stations.append(node);
                node.addLine(line)
                print("added node: \(nodeName)")
                printLines()
            }
        }
    }
    func removeNode(_ node:MetroNode) {
        for line in lines {
            if line.lineName == node.metroLine {
                if let index = line.stations.firstIndex(of: node) {
                    line.stations.remove(at: index)
                }
            }
        }
    }
    func addNewLine(lineName: String, color: UIColor) {
        lines.append(MetroLine(lineName, color))
        print("added line")
        printLines()
    }
    func getNodeByName(_ name:String) -> MetroNode? {
        //printLines()
        
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
    func getLineByName(_ name:String) -> MetroLine? {
        for line in lines {
            if line.lineName == name {
                return line
            }
        }
        return nil
    }
    func printLines() {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(self)
            let str = String(decoding:encoded, as:UTF8.self)
            print(str)
        } catch {
            print(error)
        }
        /*
        for line in lines {
            print("line: \(line.lineName)")
            for node in line.stations {
                print(node.name, " ", node.metroLine, " \n")
            }
        }
        */
    }
    
    
}
