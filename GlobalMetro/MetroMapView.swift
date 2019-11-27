//
//  MetroMapView.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
import SpriteKit
class MetroMapView: SKView {
    
    var selectedNode: MetroNode?

    func addNewNode() {
        if let scene = self.scene {
            let station1 = MetroNode(withName: "nanda", inLine: "2", center: scene.anchorPoint)
            scene.addChild(station1)
            print(station1.position)
            self.presentScene(scene)
        }
    }

}
extension MetroMapView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        if let scene = self.scene {
            let touchedNodes = scene.nodes(at:touch.location(in:scene))
        
            if let touchedNode = touchedNodes.first, ((touchedNode as? MetroNode) != nil) {
                print("node selected")
                selectedNode = touchedNode as? MetroNode
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        guard let touch = touches.first else {
                return
            }

            let positionInScene = touch.location(in: self)
            let previousPosition = touch.previousLocation(in: self)
            
            
        if let touchedNode = self.selectedNode {
                print("node moved")
                print(touchedNode.position)
                touchedNode.position = touch.location(in: self.scene!)
                print(touchedNode.position)
            } else {
                print("moved")

                self.center.x += positionInScene.x - previousPosition.x
                self.center.y += positionInScene.y - previousPosition.y
            }
        }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectedNode = nil
    }
}
