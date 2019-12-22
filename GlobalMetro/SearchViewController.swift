//
//  SearchViewController.swift
//  GlobalMetro
//
//  Created by sam on 2019/12/17.
//  Copyright © 2019 sam. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    var searchResult = ["Empty"]
    let serverURL = "http://127.0.0.1:8081"
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath)

        // Configure the cell...
        if let cell = cell as? MetroMapCell {
            cell.fileName = searchResult[indexPath.row]
            cell.textLabel?.text = String(cell.fileName!.split(separator:".")[0])

        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    // MARK: MetroMapViewController Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Map" {
            if let selectedMap = sender as? MetroMapCell,
                let mapvc = segue.destination as? MapViewController,
                let fileName = selectedMap.fileName,
                let url = URL(string: serverURL + "/get_file/" + fileName) {
                mapvc.hidesBottomBarWhenPushed = true
                mapvc.title = selectedMap.textLabel?.text
                print(url)
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                        print("Server Error: \(response)")
                        return
                    }
                    if let data = data,
                        let dataString = String(data: data, encoding: .utf8) {
                        print ("got data: \(dataString)")
                        
                        mapvc.metroMap = MetroMap(json: data)!
                        //mapvc.metroMap.printLines()
                        //mapvc.drawMap()
                    }
                }
                task.resume()
            }
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    func search(for param:String?) {
        self.searchResult.removeAll()
        self.searchResult.append("Empty")
        if let url = URL(string: serverURL + "/search?q=" + (param ??  "")) {
            print(url)
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    print("Server Error: \(response)")
                    return
                }
                if let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    for result in dataString.split(separator: " ") {
                        self.searchResult.append(String(result))
                    }
                    print ("got data: \(self.searchResult)")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            task.resume()
        }
    }
    func getDataFromServer(withFileName filename:String) -> Data? {
        
        return nil
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("TextBeginEdit")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("TextDidEndEditng")
        //search(for: searchBar.text)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       //print("TextChanged")
    }
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SearchButtonClicked")
        search(for: searchBar.text)

    }
}
