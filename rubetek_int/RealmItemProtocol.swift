//
//  RealmItemProtocol.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 22.06.2022.
//

import Foundation
import RealmSwift

protocol RealmItemProtocol {
    associatedtype RealmType: Object

    static func loadData(complition: @escaping () -> Void)
    static func getData() throws -> Results<RealmType>
    static func save(items: [RealmType], deletIfMigration: Bool, update: Realm.UpdatePolicy) throws
    static func changeFavorite(object: RealmType?) throws
    static func changeName(object: RealmType?, value: String?) throws
    var deleteIfMigration: Realm.Configuration { get }
}

extension RealmItemProtocol {

    var deleteIfMigration: Realm.Configuration {
        return Realm.Configuration(deleteRealmIfMigrationNeeded: false)
    }

    static func getData() throws -> Results<RealmType> {
        let realm = try Realm()
        return realm.objects(RealmType.self)
    }

    static func save(items: [RealmType], deletIfMigration: Bool = false,
        update: Realm.UpdatePolicy = .modified) throws {
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: deletIfMigration)
        let realm = try Realm(configuration: configuration)
            print(configuration.fileURL ?? "")
            try realm.write {
                realm.add(
                    items,
                    update: update)
            }
        }
}
