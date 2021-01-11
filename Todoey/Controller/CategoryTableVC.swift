//
//  CategoryTableVC.swift
//  Todoey
//
//  Created by Bagus setiawan on 03/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableVC: SwipeCellTableVC {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        setTableViewRow()
        
    }
    
    @IBAction func addCategoryItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newItem = Category()
            newItem.name = textField.text!
            newItem.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newItem)
            
            //self.defaults.set(self.array, forKey: "toDoListArray")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "Create New Category"
            textField = alertTexField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        print("okff")
        
    }
    
    func save(category : Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Eror saving context \(error)")
        }
        
        tableView.reloadData()
        print("save")
    }
    
    func loadCategory(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        print("ok")
    }
    
    func setTableViewRow(){
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("eror saving data \(error)")
            }
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
     
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyTableVC
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
}
