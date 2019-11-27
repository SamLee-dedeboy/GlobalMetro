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
    var selectedLine = MetroLine()
    @IBOutlet weak var metroMapView: MetroMapView! {
        didSet {
            let scene = SKScene(size: metroMapView.bounds.size)
                // Set the scene coordinates (0, 0) to the center of the screen.
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            metroMapView.presentScene(scene)
        }
    }
    @IBOutlet weak var addNodeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //TODO: addLineButtonPressed
    
    @IBAction func addNodeButtonPressed(_ sender: UIButton) {
        //TODO: show textView for input, ask the user to input station name and other info, which will be the arguments of addNewNode
        metroMapView.addNewNode()
        
        metroMap.addNewNode(inLine: selectedLine, naming:"someName")
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        metroMap.save()
    }
}

