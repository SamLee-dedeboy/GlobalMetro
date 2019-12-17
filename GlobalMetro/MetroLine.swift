//
//  MetroLine.swift
//  MetroDesignSystem
//
//  Created by sam on 2019/11/12.
//  Copyright © 2019 sam. All rights reserved.
//

import Foundation
import UIKit
class MetroLine: Codable{
    var lineName:String
    var stations = [MetroNode]()
    var color:UIColor
    init() {
        self.lineName = "someName"
        self.color = UIColor.red
    }
    init(fromFile filename:String) {
        //TODO: init line info from node files
        self.lineName = "someName"
        self.color = UIColor.red
        
    }
    init(_ name:String, _ color:UIColor) {
        self.lineName = name
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
        case lineName
        case stations
        case color
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lineName = try container.decode(String.self, forKey: .lineName)
        self.stations = try container.decode([MetroNode].self, forKey: .stations)
        
        let colorData = try container.decode(Data.self, forKey: .color)
        self.color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor ?? UIColor.black
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lineName, forKey: .lineName)
        try container.encode(stations, forKey: .stations)
        
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }
}

