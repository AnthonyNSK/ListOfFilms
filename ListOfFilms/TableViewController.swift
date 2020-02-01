//
//  TableViewController.swift
//  ListOfFilms
//
//  Created by Kuzhelev Anton on 31.01.2020.
//  Copyright © 2020 Kuzhelev Anton. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var sortedArray: [[FilmInfo]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = Model()
        model.loadData { (array, error) in
            if let array = array {
                self.sortedArray = array
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            } else if error != nil {
                
                OperationQueue.main.addOperation {
                    self.showError(error: error!)
                }
            }
        }
        
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.filmInfo = sortedArray[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let year = sortedArray[section].first?.year
        if let yearNumber = year {
        return String(yearNumber)
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView

        header.textLabel?.textAlignment = NSTextAlignment.center
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show"
        {
            let detailsController = segue.destination as! DetailsViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detailsController.filmInfo = sortedArray[indexPath.section][indexPath.row]
            }
        }
    }
    
}
