//
//  CoreDataStorage.swift
//  TodoList
//
//  Created by admin on 1/5/21.
//

import Foundation
import CoreData

final class CoreDataStorage {

    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }

    func save(title: String, subtitle: String) {
        let item = Todo(context: container.viewContext)
        item.title = title
        item.subtitle = subtitle

        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
            }
        }
    }

    func fetchTodoItems() -> [Todo] {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let predicate = NSPredicate(format: "%K BEGINSWITH[cd] %@", #keyPath(Todo.title), "убо")
        fetchRequest.predicate = predicate
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }

    func delete(item: Todo) {
        container.viewContext.delete(item)
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
            }
        }
    }

    func update() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
            }
        }
    }
}
