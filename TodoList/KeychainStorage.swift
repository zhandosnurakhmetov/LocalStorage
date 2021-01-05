//
//  KeychainStorage.swift
//  TodoList
//
//  Created by admin on 1/5/21.
//

import Foundation

class KeychainStorage {
    typealias ValueType = String

    private let serviceName: String
    private let accessGroup: String

    // MARK: Initializer
    init(serviceName: String, accessGroup: String) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }

    // MARK: Storage methods

    func set(value: String, forKey key: String) throws {
        let item = KeychainPasswordItem(service: serviceName, account: key, accessGroup: accessGroup)
        try item.savePassword(value)
    }

    func getValue(forKey key: String) -> String? {
        let item = KeychainPasswordItem(service: serviceName, account: key, accessGroup: accessGroup)
        guard let value = try? item.readPassword() else { return nil }
        return value
    }

    func getValue(forKey key: String) throws -> String {
        let item = KeychainPasswordItem(service: serviceName, account: key, accessGroup: accessGroup)
        guard let value = try? item.readPassword() else {
            return ""
        }

        return value
    }

    func deleteValue(forKey key: String) throws {
        let item = KeychainPasswordItem(service: serviceName, account: key, accessGroup: accessGroup)
        try item.deleteItem()
    }

    func deleteAll() throws {
        let items = try KeychainPasswordItem.passwordItems(forService: serviceName, accessGroup: accessGroup)
        try items.forEach { (item) in try item.deleteItem() }
    }
}
