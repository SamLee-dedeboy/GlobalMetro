//
//  ViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/11/26.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit
import SpriteKit
class MapViewController: UIViewController {
    var metroMap = MetroMap()
    var selectedLine: MetroLine? {
        //TODO: didSet: set addNodeButton disabled when this is nil
        get {
            return metroMap.selectedLine
        }
    }
    var counter = 0
    @IBOutlet weak var metroMapView: MetroMapView! {
        didSet {
            let scene = SKScene(size: metroMapView.bounds.size)
            
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            metroMapView.presentScene(scene)
            
            let pinchGestureReconizer = UIPinchGestureRecognizer(
                target:metroMapView, action: #selector(metroMapView.scaleView(pinchRecognizedBy:)))
            metroMapView.addGestureRecognizer(pinchGestureReconizer)
        }
    }
    @IBOutlet weak var addLineButton: UIButton!
    @IBOutlet weak var addNodeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //TODO: addLineButtonPressed
    
    @IBAction func addNodeButtonPressed(_ sender: UIButton) {
        //TODO: show textView for input, ask the user to input station name and other info, which will be the arguments of addNewNode
        if let selectedLine = self.selectedLine {
            print("pressed")
            let name = String(counter)
            metroMap.addNewNode(inLine: selectedLine, naming:name)
            metroMapView.drawNode(metroMap.getNodeByName(name)!)
            counter += 1

        }
    }
    
    @IBAction func addLineButtonPressed(_ sender: UIButton) {
        metroMap.addNewLine(lineName:"someName", color: UIColor.red)
    
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        metroMap.save()
    }
}

