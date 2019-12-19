//
//  ShowNodeDetailViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/12/19.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit

class ShowNodeDetailViewController: UIViewController {
    var presentedNode: MetroNode?
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)

    }
}
