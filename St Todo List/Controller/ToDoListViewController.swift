//
//  ViewController.swift
//  St Todo List
//
//  Created by Stanislav on 27/09/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var todoTable: UITableView!
    
    //MARK: - IBActions
    @IBAction func clickAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen
            guard let newItemName = textField.text else { return }
            if newItemName.count > 0 {
                let newItem = Item(name: newItemName, checked: false)
                self.itemArray.append(newItem)

//                self.defaults.set(self.itemArray, forKey: "TodoListArray")

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
        
        todoTable.delegate = self
        todoTable.dataSource = self
        
        fillArray()
        //First - use user defaults and load data from them
//        loadDataFromUserDefaults()
    }
//MARK: - tableView DataSsource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType =  item.checked ? .checkmark : .none
        return cell
    }
    
  //MARK: - tableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Load data from user defaults
    private func loadDataFromUserDefaults(){
//        guard let loadedData = defaults.array(forKey: "TodoListArray") as? [String] else { return }
//        itemArray = loadedData
    }
    
    private func addItem(name: String){
        let newItem = Item(name: name)
        itemArray.append(newItem)
    }
    
    //MARK: - Default initializations for test
    private func fillArray(){
        addItem(name: "Milk")
        addItem(name: "Water")
        addItem(name: "Cola")
        addItem(name: "Meat")
        addItem(name: "Orange")
        addItem(name: "Cucumber")
        addItem(name: "Candies")
        addItem(name: "Juice")
        addItem(name: "Potato")
        addItem(name: "Tomato")
        addItem(name: "Bread")
        addItem(name: "Eggs")
        addItem(name: "Apples")
        addItem(name: "1")
        addItem(name: "2")
        addItem(name: "3")
        addItem(name: "4")
        addItem(name: "5")

    }
}

