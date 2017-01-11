//
//  ToDoViewController.swift
//  Firebase-iOS
//
//  Created by Jaison on 11/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ToDoTableViewController: UITableViewController {
    
    let FIREBASE_TABLENAME = "todo"
    
    fileprivate var refHandle: FIRDatabaseHandle!
    var ref: FIRDatabaseReference!
    var todos: [FIRDataSnapshot]! = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ToDoTableViewCell")
        configureFirebaseDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Listen for new messages in the Firebase database
        refHandle = self.ref.child(FIREBASE_TABLENAME).observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.todos.append(snapshot)
            strongSelf.tableView.insertRows(at: [IndexPath(row: strongSelf.todos.count-1, section: 0)], with: .automatic)
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.ref.child(FIREBASE_TABLENAME).removeObserver(withHandle: refHandle)
    }
    
    func configureFirebaseDB() {
        ref = FIRDatabase.database().reference()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ToDoTableViewCell
        cell.toggle()
        
        let data = todos[indexPath.row].value as! Dictionary<String, Any>
        let isToDoChecked = !(data[ToDoFieldConstant.isComplete] as? Bool ?? false)
        
        self.ref.child(FIREBASE_TABLENAME + "/\(todos[indexPath.row].key)").updateChildValues([ToDoFieldConstant.isComplete : isToDoChecked])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell") as! ToDoTableViewCell
        let data = todos[indexPath.row].value as! Dictionary<String,Any>
        cell.setUpCell(isChecked: data[ToDoFieldConstant.isComplete] as? Bool ?? false, description: data[ToDoFieldConstant.description] as? String ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            deleteATodo(todo: todos[indexPath.row], completion: { 
                self.todos.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func onAddToDoClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create a new to-do", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            self.addTodo(newTodo: alert.textFields![0].text!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLogoutClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (action) in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        } catch let error {
            showErrorAlert(message: error.localizedDescription, completion: nil)
        }
    }
    
    
    func addTodo(newTodo: String) {
        let todoData = [
            ToDoFieldConstant.description : newTodo,
            ToDoFieldConstant.createdAt   : Date().getString,
            ToDoFieldConstant.isComplete  : false
            ] as [String : Any]
        
        self.ref.child(FIREBASE_TABLENAME).childByAutoId().setValue(todoData)
    }
    
    func deleteATodo(todo: FIRDataSnapshot, completion: @escaping () -> Void) {
        self.ref.child(FIREBASE_TABLENAME + "/\(todo.key)").removeValue { (error, ref) in
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription, completion: nil)
            } else {
                completion()
            }
        }
    }
    
}
