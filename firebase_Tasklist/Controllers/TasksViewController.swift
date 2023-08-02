//
//  TasksViewController.swift
//  firebase_Tasklist
//
//  Created by Igor on 01.08.2023.
//

import UIKit
import FirebaseAuth

class TasksViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "New Task",
            message: "Add new task",
            preferredStyle: .alert
        )
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
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
