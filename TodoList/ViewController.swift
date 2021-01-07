//
//  ViewController.swift
//  TodoList
//
//  Created by admin on 1/5/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let localStorage = CoreDataStorage()
    private var items: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TodoListCell.self, forCellReuseIdentifier: "Identifier")
        items = localStorage.fetchTodoItems()
    }

    @IBAction func addButtonDidPress(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Что хотите добавить?", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Title"
        }
        alert.addTextField { textField in
            textField.placeholder = "Subtitle"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            let title = alert.textFields?[0].text ?? ""
            let subtitle = alert.textFields?[1].text ?? ""
            self?.localStorage.save(title: title, subtitle: subtitle)
            self?.reloadTableView()
        }

        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func showEditAlert(item: Todo) {
        let alert = UIAlertController(title: "Что хотите изменить?", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = item.title
        }
        alert.addTextField { textField in
            textField.text = item.subtitle
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }

        let addAction = UIAlertAction(title: "Edit", style: .default) { [weak self] action in
            let title = alert.textFields?[0].text ?? ""
            let subtitle = alert.textFields?[1].text ?? ""
            item.title = title
            item.subtitle = subtitle
            self?.localStorage.update()
            self?.reloadTableView()
        }

        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func reloadTableView() {
        items = localStorage.fetchTodoItems()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier", for: indexPath) as! TodoListCell
        cell.titleLabel.text = items[indexPath.row].title
        cell.subtitleLabel.text = items[indexPath.row].subtitle
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else { return }
            self.localStorage.delete(item: self.items[indexPath.row])
            self.reloadTableView()
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, _) in
            guard let self = self else { return }
            let item = self.items[indexPath.row]
            self.showEditAlert(item: item)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
