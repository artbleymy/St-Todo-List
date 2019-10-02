//
//  ViewController.swift
//  St Todo List
//
//  Created by Stanislav on 27/09/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var itemArray = [Item]()
    var selectedCategory : Categories? {
        didSet {
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - IBActions
    @IBAction func clickAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen
            guard let newItemName = textField.text else { return }
            if newItemName.count > 0 {
                let newItem = Item(context: self.context)
                newItem.name = newItemName
                newItem.checked = false
                newItem.parentCategory = self.selectedCategory
                
//                self.itemArray.append(newItem)
                self.itemArray.insert(newItem, at: 0)
                
                self.saveItems()
                
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
        
//        print(dataFilePath)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        todoTable.delegate = self
        todoTable.dataSource = self
        searchBar.delegate = self
        
//        fillArray()
        //First - use user defaults and load data from them
//        loadDataFromUserDefaults()
        //Second - use file and encodable/decodable class to load
//        loadDataFromFile()
        //Third - use CoreData
//        loadItems()
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
  
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(index: indexPath.row)
        } else if editingStyle == .insert {
            
        }
    }
    //MARK: - tableView Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Load data from user defaults
    private func loadDataFromUserDefaults(){
//        guard let loadedData = defaults.array(forKey: "TodoListArray") as? [String] else { return }
//        itemArray = loadedData
    }
    
    
    //MARK: - Data manipulating methods
    
    //Load data from file (decodable class required)
       private func loadDataFromFile(){
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error while loading \(error)")
//            }
//        }

       }
    //Load data from context
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),
                           predicate: NSPredicate? = nil){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        guard let category = selectedCategory, let categoryName = category.name  else { return }
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
        
        var compoundPredicate: NSCompoundPredicate
        if let additionPredicate = predicate {
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionPredicate])
        } else {
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
        }
        
        
        request.predicate = compoundPredicate
        request.sortDescriptors = [NSSortDescriptor(key: "checked", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        do {
            itemArray = try  context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        if let table = todoTable {
            table.reloadData()
        }
    }
    
    //Save data to context
    private func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error while saving \(error)")
        }
        todoTable.reloadData()

    }
    
    //Delete data from context
    private func deleteItem(index: Int){
        context.delete(itemArray[index])
        itemArray.remove(at: index)
        saveItems()
        
        todoTable.reloadData()
    }
}
    //MARK: - Search bar  methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.count > 0 {
            applyFilter(with: searchText)
        } else {
            loadItems()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            //HIDE KEYBOARD AND CHANGE FOCUS FROM SEARCH BAR
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
        }
    }
    
    func applyFilter(with searchText: String){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    
    
}
