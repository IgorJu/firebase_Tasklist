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

    //MARK: - Properties
    @IBOutlet var tableView: UITableView!
    
    var user: UserS!
    var ref: DatabaseReference!
    var tasks: [Task] = []
    
    //MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserS(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] snapshot in
            var _tasks: [Task] = []
            for item in snapshot.children {
                let task = Task(snapShot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            
            //настройка анимации при добавлении новых ячеек
            let oldCount = self?.tableView.numberOfRows(inSection: 0) ?? 0
            if oldCount != _tasks.count {
                self?.tableView.beginUpdates()
                let indexPathsToInsert = self?.indexPathsToInsert(from: oldCount, to: _tasks.count)
                self?.tableView.insertRows(at: indexPathsToInsert ?? [], with: .fade)
                self?.tableView.endUpdates()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    //MARK: - IBAction funcs
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
            
            let newCellIndexPath = IndexPath(row: self?.tasks.count ?? 0, section: 0)
            self?.tasks.append(task)
            self?.tableView.insertRows(at: [newCellIndexPath], with: .fade)
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
    
    //MARK: - Private func
    //вспомогательная функция для анимации добавления ячеек
    private func indexPathsToInsert(from oldCount: Int, to newCount: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for i in oldCount..<newCount {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        return indexPaths
    }
}

//MARK: - Extension UITableViewDelegate, DataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        

        let taskTitle = tasks[indexPath.row].title
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = .white
        content.text = taskTitle
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
