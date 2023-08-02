//
//  TasksViewController.swift
//  firebase_Tasklist
//
//  Created by Igor on 01.08.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TasksViewController: UIViewController {

    var user: UserS!
    var ref: DatabaseReference!
    //var tasks = Array<Task>()
    var tasks: [Task] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserS(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "New Task",
            message: "Add new task",
            preferredStyle: .alert
        )
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(["title": task.title, "userId": task.userId, "completed": task.completed])
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
    
    @IBAction func signOutButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true)
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = .white
        cell.contentConfiguration = content
        return cell
    }
    
    
}
