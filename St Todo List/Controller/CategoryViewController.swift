//
//  CategoryViewController.swift
//  St Todo List
//
//  Created by Stanislav on 02/10/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryArray = [Categories]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - IBOutlets
    @IBOutlet weak var categoryTable: UITableView!
    
    //MARK: - IBActions
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()

                let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Add item", style: .default) { (action) in
                    //what will happen
                    guard let newCategoryName = textField.text else { return }
                    if newCategoryName.count > 0 {
                        let newCategory = Categories(context: self.context)
                        newCategory.name = newCategoryName
                        
                        self.categoryArray.insert(newCategory, at: 0)
                        
                        self.saveCategories()
                        
                    }
                }
                
                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create new category"
                    textField = alertTextField
                }
         
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Table view delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(index: indexPath.row)
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Go inside the category")
        performSegue(withIdentifier: "goToItems", sender: self)
        categoryTable.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ToDoListViewController{
            if let indexPath = categoryTable.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTable.dataSource = self
        categoryTable.delegate = self
        
        loadCategories()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Data manipulation functions
    private func loadCategories(with request: NSFetchRequest<Categories> = Categories.fetchRequest()){
        do {
            categoryArray = try  context.fetch(request)
        } catch {
            print("Error fetching categories from context \(error)")
        }
        categoryTable.reloadData()
        
    }
    
    private func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error while saving \(error)")
        }
        categoryTable.reloadData()
        
    }
    
    //Delete data from context
       private func deleteItem(index: Int){
           context.delete(categoryArray[index])
           categoryArray.remove(at: index)
           saveCategories()
           
           categoryTable.reloadData()
       }
  

}
