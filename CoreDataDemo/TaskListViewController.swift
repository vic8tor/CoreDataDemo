//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Victor on 25.01.2022.
//

import UIKit

enum Actions {
    case add, edit
}

class TaskListViewController: UITableViewController {
    
    
// MARK: - Private Properties
    let context = StorageManager.shared.persistentContainer.viewContext
    private let cellID = "task"
    private var taskList: [Task] = []
    private var indexPathForSelectedRow: IndexPath?
    
// MARK: - Override Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
        
// MARK: - Private Methods
  
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarApperence = UINavigationBarAppearance()
        navBarApperence.configureWithOpaqueBackground()
        navBarApperence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApperence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarApperence.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255)
        navigationController?.navigationBar.standardAppearance = navBarApperence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperence
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask))
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?", action: .add)
    }

    private func fetch() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                self.taskList = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showAlert(with title: String, and message: String, action: Actions) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var saveAction: UIAlertAction
        switch action {
        case .add:
            saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
                self.add(task)
            }
        case .edit:
            saveAction = UIAlertAction(title: "Rename", style: .default) { _ in
                guard let task = alert.textFields?.first?.text, !task.isEmpty, let indexPath = self.indexPathForSelectedRow else { return }
                self.edit(at: indexPath, task)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        present(alert,animated: true)
    }
    
    private func add(_ taskName: String) {
        StorageManager.shared.addTask(taskName) { task in
            self.taskList.append(task)
        }

        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .top)
        
        StorageManager.shared.saveContext()
    }
    
    private func edit(at indexPath: IndexPath, _ taskName: String) {
        StorageManager.shared.addTask(taskName) { task in
            self.taskList[indexPath.row] = task
            self.tableView.reloadRows(at: [indexPath], with: .top)
        }
        
        StorageManager.shared.saveContext()
    }
}

// MARK: - Extension
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            StorageManager.shared.deleteTask(at: indexPath.row, for: self.taskList)
            self.taskList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .top)
        }
        
        let actionEdit = UIContextualAction(style: .normal, title: "Edit") { action, view, completion in
            self.showAlert(with: "Edit Task", and: "Please enter new name for Task", action: .edit)
        
        }
        actionEdit.backgroundColor = .systemOrange
        actionEdit.image = UIImage(systemName: "square.and.pencil")
        
        let config = UISwipeActionsConfiguration(actions: [actionDelete, actionEdit])
        return config
    }
    
}
