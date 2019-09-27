//
//  ViewController.swift
//  St Todo List
//
//  Created by Stanislav on 27/09/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemArray = ["Milk", "Potatoes", "Water"]
    
    @IBOutlet weak var todoTable: UITableView!
    
    //MARK: - IBActions
    @IBAction func clickAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen
            guard let newItem = textField.text else { return }
            if newItem.count > 0 {
                self.itemArray.append(newItem)
                self.todoTable.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
 
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoTable.delegate = self
        todoTable.dataSource = self
    }
//MARK: - tableView DataSsource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
  //MARK: - tableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        itemArray.remove(at: indexPath.row)
//        todoTable.reloadData()
        tableView.cellForRow(at: indexPath)?.accessoryType = (tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none) ? .checkmark : .none

        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

