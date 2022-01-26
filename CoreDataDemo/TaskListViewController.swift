//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Victor on 25.01.2022.
//

import UIKit

class TaskListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }

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
        let newTask = TaskListViewController()
        present(newTask, animated: true)
        
    }
    
}

