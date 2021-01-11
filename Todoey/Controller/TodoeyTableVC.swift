//
//  TodoeyTableVC.swift
//  Todoey
//
//  Created by Bagus setiawan on 03/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoeyTableVC: SwipeCellTableVC {
    
    
    var array : Results<Items>?
    
    let realm = try! Realm()
    //let defaults = UserDefaults.standard
    
    var selectedCategory : Category? {
        didSet{
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewRow()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory?.name
            guard let navBar = navigationController?.navigationBar else {fatalError("navigaition Controller does not exist")}

            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                
            }
        }
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add Item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Items()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("Eror saving data")
                }
            }
            
            self.tableView.reloadData()
            
            
        }
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "Create New Item"
            textField = alertTexField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func loadItem() {
        
        array = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView?.reloadData()
        print("ok")
    }
    func setTableViewRow(){
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.array?[indexPath.row] {
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
        return array?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath )
        cell.textLabel?.text = array?[indexPath.row].title
        
        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(array!.count)){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        
        cell.accessoryType = array?[indexPath.row].status == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = array?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item) (function to delete file in realm)
                    item.status = !item.status
                }
            } catch {
                print("eror saving data \(error)")
            }
        }
        self.tableView.reloadData()
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension TodoeyTableVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        array = array?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}
