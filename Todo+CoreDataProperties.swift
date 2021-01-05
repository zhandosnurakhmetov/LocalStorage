//
//  Todo+CoreDataProperties.swift
//  TodoList
//
//  Created by admin on 1/5/21.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?

}

extension Todo : Identifiable {

}
