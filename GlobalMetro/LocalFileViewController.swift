//
//  LocalFileViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/12/19.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit

class LocalFileViewController: UITableViewController {
    var localFileList = ["Empty"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillLayoutSubviews() {
        if let url = try? FileManager.default.url(
            for:.documentDirectory,
            in:.userDomainMask,
            appropriateFor: nil,
            create: true
            ) {
            do {
                print(url.absoluteString)
                //print(try String(contentsOf:url))
                let items = try FileManager.default.contentsOfDirectory(
                    at: url,
                    includingPropertiesForKeys: nil,
                    options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                localFileList.removeAll()
                for item in items {
                    localFileList.append(String(item.absoluteString.split(separator: "/").last ?? ""))
                }
            } catch let error {
                print("failed to get items with error: \(error)")
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localFileList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocalMapCell", for: indexPath)

        // Configure the cell...
        if let cell = cell as? MetroMapCell {
            cell.fileName = localFileList[indexPath.row]
            cell.textLabel?.text = String(cell.fileName!.split(separator:".")[0])

        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Local Map" {
            if let selectedMap = sender as? MetroMapCell,
                let mapvc = segue.destination as? MapViewController,
                let fileName = selectedMap.fileName {
                if let url = try? FileManager.default.url(
                    for:.documentDirectory,
                    in:.userDomainMask,
                    appropriateFor: nil,
                    create: true
                ).appendingPathComponent(fileName) {
                    if let jsonData = try? Data(contentsOf: url) {
                        mapvc.metroMap = MetroMap(json: jsonData)!
      
                    }
                }
            }
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let fileName = localFileList[indexPath.row]
        if editingStyle == .delete {
            if let url = try? FileManager.default.url(
                for:.documentDirectory,
                in:.userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent(fileName) {
                print("deleting:")
                let deleteResult = try? FileManager.default.removeItem(at: url)
                // Delete the row from the data source
                print(deleteResult)
                localFileList.remove(at:indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
