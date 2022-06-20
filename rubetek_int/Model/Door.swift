//
//  Door.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation
import RealmSwift

class Door: Object, Item, Codable {

    @Persisted(primaryKey: true) var id: Int?
    @Persisted var name: String?
    @Persisted var snapshot: String?
    @Persisted var room: String?
    @Persisted var favorites: Bool?
    @Persisted var userName: String?
}
