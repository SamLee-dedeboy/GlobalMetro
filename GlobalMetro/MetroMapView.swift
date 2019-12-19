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
    //var mapInfo = [String:[MetroNode]]()
    var selectedNode: SKNode?
    var isEditMode = false {
        didSet {
            if let mvc = self.delegate as? MapViewController {
                mvc.editModeDidChange()
            }
        }
    }
    var selectedLine: String? {
        didSet {
            if let mvc = self.delegate as? MapViewController {
                mvc.selectedLineDidChange()
            }
        }
        
    }
 
    /*
    func drawMap() {
        //TODO: optimized so that each line is on different layer
        let newScene = SKScene(size: self.bounds.size)
        
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        for nodeList in mapInfo.values {
            if var lastNode = nodeList.first {
                lastNode.removeFromParent()
                newScene.addChild(lastNode)
                if nodeList.count > 1 {
                    for node in nodeList[1...] {
                        node.removeFromParent()

                        drawLineBetweenNode(onScene: newScene, lastNode, node)
                        newScene.addChild(node)
                        lastNode = node
                    }
                }
            }
        }
        presentScene(newScene)
    }
 */
    func drawMap(_ mapInfo: [String:[MetroNode]]) {
        
    }
    /*
    func drawNode(_ node:MetroNode) {
        if mapInfo[node.metroLine] != nil {
            print("add1")
            let lastNode = mapInfo[node.metroLine]!.last!
            mapInfo[node.metroLine]!.append(node)
            node.adjacentNodes.append(lastNode.stationName)
            lastNode.adjacentNodes.append(node.stationName)
            drawLineBetweenNode(onScene: self.scene!, node, lastNode)
            self.scene!.addChild(node)

        } else {
            print("add2")
            mapInfo[node.metroLine] = [node]
            self.scene!.addChild(node)
            //self.presentScene(self.scene!)
        }
        highlightNode(node, onScene: self.scene!)
    }
*/
    /*
    @objc func scaleView(pinchRecognizedBy recognizer: UIPinchGestureRecognizer) {
        print("recognized")
        self.transform = CGAffineTransform.identity.scaledBy(x: recognizer.scale, y: recognizer.scale)
    }
 */
}

extension MetroMapView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch began")
        guard let touch = touches.first else {
            return
        }
        if let scene = self.scene {
            let touchedNodes = scene.nodes(at:touch.location(in:scene))
          
            if let touchedNode = touchedNodes.first {
          
                if let touchedNodeInnerCircle = touchedNode as? SKShapeNode, let touchedMetroNode = touchedNodeInnerCircle.parent as? MetroNode {
                        print("touched metroNode: ",  touchedMetroNode)
                    if let mvc = self.delegate as? MapViewController {
                        mvc.highlightLine(touchedMetroNode.metroLine)
                    }
                    selectedNode = touchedMetroNode
                    selectedLine = touchedMetroNode.metroLine
                    print("returning")
                    return
                } else if let touchedLabelNode = touchedNode as? SKLabelNode {
                    if isEditMode {
                        print("selected label:\(touchedLabelNode.text)")
                        selectedNode = touchedLabelNode
                        selectedLine = (touchedLabelNode.parent as? MetroNode)?.metroLine
                        return
                    }
                }
             
            } else {
                print("no nodes")
            }
            if selectedNode != nil {
                if let mvc = self.delegate as? MapViewController, let selectedNode = selectedNode as? MetroNode {
                    mvc.deHighlightLine(selectedNode.metroLine)
                }
            }
            selectedNode = nil
            selectedLine = nil
        } else {
            print("no scene")
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEditMode {
            if let mvc = self.delegate as? MapViewController {
                mvc.handleTouchesMoved(touches, with: event)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch ended")
        superview?.isUserInteractionEnabled = true
        if isEditMode {
            if let selectedNode = self.selectedNode as? MetroNode {
                selectedNode.coordinateInMap = selectedNode.position
            }
            if let selectedNode = self.selectedNode as? SKLabelNode, let parentNode = selectedNode.parent as? MetroNode {
                parentNode.labelPosition = selectedNode.position
            }
        } else {
            if let selectedNode = self.selectedNode as? MetroNode,
                let mvc = self.delegate as? MapViewController {
                mvc.showNodeDetail(selectedNode)
            }
        }
        self.selectedNode = nil

    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch canceled")
        superview?.isUserInteractionEnabled = true
        if let selectedNode = self.selectedNode as? MetroNode {
            selectedNode.coordinateInMap = selectedNode.position
        }
        if let selectedNode = self.selectedNode as? SKLabelNode, let parentNode = selectedNode.parent as? MetroNode {
            parentNode.labelPosition = selectedNode.position
        }
        self.selectedNode = nil
    
    }
}
    /*
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
            for adjacentNodeName in touchedNode.adjacentNodes {
                if let adjacentNode = mapInfo.getNodeByName(adjacentNodeName) {
                    self.scene!.removeChildren(in:[
                        (self.scene!.childNode(withName:
                            touchedNode.stationName + "-" + adjacentNode.stationName))
                            ??
                            (self.scene!.childNode(withName:
                                adjacentNode.stationName + "-" + touchedNode.stationName))!                    ]
                    )
                    drawLineBetweenNode(onScene: self.scene!, touchedNode, adjacentNode)
                }
            }

            //drawMap()
            print(touchedNode.position)
        } else {
            print("moved")

            //self.center.x += positionInScene.x - previousPosition.x
            //self.center.y += positionInScene.y - previousPosition.y
        }
    }
    
    override var next: UIResponder? {
        get {
            return nil
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
}
extension MetroMapView {
    func drawLineBetweenNode(onScene scene:SKScene, _ src:MetroNode, _ dst:MetroNode) {
        //TODO: cut out lines in the circle
        let path = CGMutablePath()
        path.move(to: src.position)
        path.addLine(to: dst.position)
        let line = SKShapeNode(path:path)
        line.name = src.stationName + "-" + dst.stationName
        line.lineWidth = 30
        line.glowWidth = 0.5
        line.strokeColor = src.lineColor
        line.zPosition = src.zPosition - 1
        scene.addChild(line)
        print("addNewLine:\(src.metroLine), \(src.lineColor)")
        //self.presentScene(scene)
    }
    func highlightLine(_ lineName: String) {
        if let scene = self.scene {
            if let line = mapInfo[lineName] {
                for node in line {
                    highlightNode(node, onScene: scene)
                }
            }
        }
    }
    func highlightNode(_ node:MetroNode, onScene scene:SKScene) {
        let path = CGMutablePath()
        path.addArc(center: node.coordinateInMap,
                        radius: 20,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        node.path = path
        print("highlighted")
    }
    func deHighlightLine(_ lineName: String) {
        if let scene = self.scene {
            if let line = mapInfo[lineName] {
                for node in line {
                    deHighlightNode(node, onScene: scene)
                }
            }
        }
    }
    func deHighlightNode(_ node:MetroNode, onScene scene:SKScene) {
        let path = CGMutablePath()
        path.addArc(center: node.coordinateInMap,
                        radius: 15,
                        startAngle: 0,
                        endAngle: CGFloat.pi * 2,
                        clockwise: true)
        node.path = path
        print("dehighlighted")
    }
}
*/
