//
//  ViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
import SpriteKit
class MapViewController: UIViewController, SKViewDelegate, UIScrollViewDelegate {
    var metroMap = MetroMap()
   
    func showNodeDetail(_ node: MetroNode) {
        performSegue(withIdentifier: "Show Node Detail", sender: node)
    }
    func editModeDidChange() {
        buttonStackView.isHidden = !self.metroMapView.isEditMode
        if self.metroMapView.isEditMode {
            self.cancelEditButton.isEnabled = true
            self.editButtonItem.isEnabled = false
        } else {
            self.cancelEditButton.isEnabled = false
            self.editButtonItem.isEnabled = true
        }
    }
    func selectedLineDidChange() {
        if self.metroMapView.isEditMode {
            if let metroMapView = self.metroMapView {
                if metroMapView.selectedLine == nil {
                    addNodeButton.isEnabled = false
                } else {
                    addNodeButton.isEnabled = true
                }
                print("selectedLine didSet: \(metroMapView.selectedLine)")

            }
        }
    }
    //var selectedNode: MetroNode?
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Create Node" {
        
            if let cnvc = segue.destination as? CreateNodeViewController {
                if let ppc = cnvc.popoverPresentationController {
                    ppc.sourceRect = addNodeButton.frame
                    ppc.delegate = self
                    cnvc.preferredContentSize = CGSize(width: 250, height: 500)
                }
            }
            return
        }
        
        if segue.identifier == "Create Line" {
            if let clvc = segue.destination as? CreateLineViewController {
                if let ppc = clvc.popoverPresentationController {
                    ppc.sourceRect = addLineButton.frame
                    ppc.delegate = self
                    clvc.preferredContentSize = CGSize(width: 250, height:500)
                }
            }
            return
        }
        
        if segue.identifier == "Save Map" {
            if let smvc = segue.destination as? SaveMapViewController {
                if let ppc = smvc.popoverPresentationController {
                    ppc.sourceRect = saveButton.frame
                  
                    ppc.delegate = self
                    smvc.preferredContentSize = CGSize(width:250, height:500)
                }
            }
        }
        
        if segue.identifier == "Show Node Detail" {
            if let sndvc = segue.destination as? ShowNodeDetailViewController,
                let presentedNode = sender as? MetroNode {
                sndvc.presentedNode = presentedNode
                
            }
        }
    }
    
    var counter = 0
    // MARK: view outlet
    @IBOutlet weak var metroMapView: MetroMapView! {
        didSet {
            
            let scene = SKScene(size: metroMapView.bounds.size)
            scene.backgroundColor = UIColor.white
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            metroMapView.delegate = self
            metroMapView.presentScene(scene)

            //let pinchGestureReconizer = UIPinchGestureRecognizer(
                //target:metroMapView, action: #selector(metroMapView.scaleView(pinchRecognizedBy:)))
            //metroMapView.addGestureRecognizer(pinchGestureReconizer)
        }
    }
    
    @IBOutlet weak var mapScrollView: myScrollView! {
        didSet {
            mapScrollView.minimumZoomScale = 1/25
            mapScrollView.maximumZoomScale = 1.2
            mapScrollView.delegate = self
            mapScrollView.canCancelContentTouches = true
            
        }
    }
    // MARK: button outlet
    @IBOutlet weak var addLineButton: UIButton!
    @IBOutlet weak var addNodeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var cancelEditButton: UIBarButtonItem!
    
    
    //@IBOutlet weak var toolBar: UIToolbar!
    // MARK: VC lifecycle
    override func viewWillLayoutSubviews() {
        mapScrollView.contentSize = metroMapView.frame.size
        print(mapScrollView.contentSize)
        //mapScrollView.setContentOffset(CGPoint(x: -metroMapView.center.x, y: -metroMapView.center.y), animated: false)
        //mapScrollView.contentOffset = CGPoint(x: -metroMapView.center.x, y: -metroMapView.center.y)
        print(mapScrollView.contentOffset)
        mapScrollView.bounces = false
        mapScrollView.bouncesZoom = false
        print(mapScrollView.contentInset)

    }
    override func viewDidLayoutSubviews() {
        //drawMap()
    }
    override func viewDidAppear(_ animated: Bool) {
        drawMap()
        //self.toolBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //metroMapView.frame = CGRect(x: 0, y: 0, width: 1200, height: 800)

    


        
        
        do {
            //var node:MetroNode = try .init(fromFile: "test_node.json")
        
        } catch {
            print("init from file failed")
        }
    }
    
    
    //MARK: Action
    @IBAction func testButtonPressed(_ sender: UIButton) {
    
        print(metroMapView.center)
        /*
        metroMapView.drawNode(MetroNode(withName: "1", inLine: "2", center:CGPoint(x:0.5,y:0.5)))
        metroMapView.drawNode(MetroNode(withName: "2", inLine: "2", center:CGPoint(x:0.5,y:0.5)))
        metroMapView.drawNode(MetroNode(withName: "3", inLine: "2", center:CGPoint(x:0.5,y:0.5)))
        metroMapView.drawNode(MetroNode(withName: "4", inLine: "2", center:CGPoint(x:0.5,y:0.5)))
 */
    }
    func createNode(_ name: String) {
        
        if let selectedLine = self.metroMapView.selectedLine {
            print("pressed")
            metroMap.addNewNode(inLine: selectedLine, naming:name)
            drawNode(metroMap.getNodeByName(name)!)
        
        }
    }
    func createLine(_ name:String, _ color:UIColor) {
        metroMap.addNewLine(lineName: name, color: color)
        self.metroMapView.selectedLine = name
    }

    func saveMap(withName mapName:String) {
        self.metroMap.mapName = mapName
        if let json = metroMap.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(mapName + ".json") {
                do {
                    try json.write(to:url)
                    print("map saved at \(url)")
                } catch let error {
                    print("save file failed: \(error)")
                }
            }
        }
        
    }
    @IBAction func loadButtonPressed(_ sender: UIButton) {
        if let url = try? FileManager.default.url(
            for:.documentDirectory,
            in:.userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("metroMap.json") {
            if let jsonData = try? Data(contentsOf: url) {
                metroMap = MetroMap(json: jsonData)!
                metroMap.printLines()
                drawMap()
               // drawNode(MetroNode(withName: "???", inLine: "1", center: CGPoint.zero))
            }
        }
    }
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        let url = URL(string: "http://127.0.0.1:8081")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //TODO: check save
        
        let uploadData = metroMap.json
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            print("got response:", response)
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.metroMapView.isEditMode = true
    }
    @IBAction func cancelEditButtonPressed(_ sender: UIBarButtonItem) {
        self.metroMapView.isEditMode = false
    }
}
// MARK: popover extension
extension MapViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return metroMapView
    }
}
// MARK: subclass Scroll View
class myScrollView: UIScrollView {
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        print("check touch")
        
        if let metroMapView = subviews.first as? MetroMapView {
            return metroMapView.selectedNode == nil
        } else {
            return true
        }
 
    }
 
    /*
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        if let metroMapView = subviews.first as? MetroMapView {
            if metroMapView.selectedNode != nil {
                self.isUserInteractionEnabled = false
            } else {
                self.isUserInteractionEnabled = true
            }
        }
        return true
    }
    */
}
// MARK: touch event handlers
extension MapViewController {

    func handleTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        guard let touch = touches.first else {
            return
        }
                        
        if let touchedNode = self.metroMapView.selectedNode as? MetroNode{
            let lastPosition = touchedNode.position
            touchedNode.position = touch.location(in: self.metroMapView.scene!)
            print("node moved from \(lastPosition) to \(touchedNode.position)")
                
            //redraw line
            for adjacentNodeName in touchedNode.adjacentNodes {
                if let adjacentNode = metroMap.getNodeByName(adjacentNodeName) {
                    if let scene = self.metroMapView.scene {
                        scene.removeChildren(in:[
                            (scene.childNode(withName:
                                touchedNode.stationName + "-" + adjacentNode.stationName))
                                ??
                                (scene.childNode(withName:
                                    adjacentNode.stationName + "-" + touchedNode.stationName))!                    ]
                        )
                        drawLineBetweenNode(onScene: scene, touchedNode, adjacentNode)
                    }
                }
            }

            //drawMap()
            print(touchedNode.position)
        } else if let touchedNode = self.metroMapView.selectedNode as? SKLabelNode, let parentNode = touchedNode.parent {
            let lastPosition = touchedNode.position
            let parentPosition = parentNode.position
            
            let touchPosition = touch.location(in: parentNode)
            touchedNode.position = touchPosition
            print("Label moved from: \(lastPosition) to \(touchedNode.position)")
            //self.center.x += positionInScene.x - previousPosition.x
            //self.center.y += positionInScene.y - previousPosition.y
        }
    }
    
    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch ended")
        mapScrollView?.isUserInteractionEnabled = true

        self.metroMapView.selectedNode = nil
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch canceled")
        mapScrollView?.isUserInteractionEnabled = true

        self.metroMapView.selectedNode = nil
    }
 */
    override var next: UIResponder? {
        get {
            return nil
        }
    }

}
// MARK: draw functions
extension MapViewController {
    func drawNode(_ node:MetroNode) {
        print("darwing node on \(node.position)")
        if let line = metroMap.getLineByName(node.metroLine) {
            if line.stations.count >= 1 {
                print("add1")
                self.metroMapView.scene!.addChild(node)

                for adjacentNodeName in node.adjacentNodes {
                    if let adjacentNode = metroMap.getNodeByName(adjacentNodeName) {
                        if noLineBetweenNode(node, adjacentNode) {
                            drawLineBetweenNode(onScene: self.metroMapView.scene!, node, adjacentNode)
                        }
                    }
                    
                }

            } else {
                print("add2")
                //line.stations.append(node)
                self.metroMapView.scene!.addChild(node)
                //self.presentScene(self.scene!)
            }
            highlightNode(node, onScene: self.metroMapView.scene!)
        }
    }
    func drawLineBetweenNode(onScene scene:SKScene, _ src:MetroNode, _ dst:MetroNode) {
        //TODO: cut out lines in the circle
        let path = CGMutablePath()
        path.move(to: src.position)
        path.addLine(to: dst.position)
        let line = SKShapeNode(path:path)
        line.name = src.stationName + "-" + dst.stationName
        line.lineWidth = 40
        line.glowWidth = 0.5
        line.strokeColor = src.lineColor
        //line.strokeColor = UIColor.blue
        line.zPosition = src.zPosition - 1
        scene.addChild(line)
        print("addNewLine:\(src.position), \(dst.position)")
        print(scene.children)
        //self.presentScene(scene)
    }
    func highlightLine(_ lineName: String) {
        if let scene = self.metroMapView.scene {
            if let line = metroMap.getLineByName(lineName) {
                for node in line.stations {
                    highlightNode(node, onScene: scene)
                }
            }
        }
    }
    func highlightNode(_ node:MetroNode, onScene scene:SKScene) {
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
        radius: 20,
        startAngle: 0,
        endAngle: CGFloat.pi * 2,
        clockwise: true)
        
        node.path = path
        print("highlighted: \(node.stationName)")
    }
    func deHighlightLine(_ lineName: String) {
        if let scene = self.metroMapView.scene {
            if let line = metroMap.getLineByName(lineName) {
                for node in line.stations {
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
    func noLineBetweenNode(_ src:MetroNode, _ dst:MetroNode) -> Bool {
        if let scene = self.metroMapView.scene {
            for childNode in scene.children {
                if (childNode.name == src.stationName + "-" + dst.stationName) ||
                    (childNode.name == dst.stationName + "-" + src.stationName) {
                    return false
                }
            }
        }
        return true
    }
    func drawMap() {
        print("drawing Map")
        if let scene = self.metroMapView.scene {
            //draw Nodes
            for line in metroMap.lines {
                for node in line.stations {
                    node.name = node.stationName
                    if node.name == "123" {
                      //  node.position = CGPoint(x: 100, y: 100)
                    }
                    scene.addChild(node)
                    highlightNode(node, onScene: scene)
                    print("added Node on :",node.position )
                }
            }
            //draw Lines
            for line in metroMap.lines {
                for node in line.stations {
                     for adjacentNodeName in node.adjacentNodes {
                        if let adjacentNode = metroMap.getNodeByName(adjacentNodeName) {
                            if noLineBetweenNode(node, adjacentNode) {
                                drawLineBetweenNode(onScene: scene, node, adjacentNode)
                            }
                        }
                                       
                    }

                }
            }
        }
    }
}
