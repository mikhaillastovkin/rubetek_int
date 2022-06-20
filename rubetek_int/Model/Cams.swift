//
//  Cams.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation
import RealmSwift

class Cameras: Codable {
    var cameras: [Camera]
}

class Camera: Object, Item, Codable {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var name: String?
    @Persisted var snapshot: String?
    @Persisted var room: String?
    @Persisted var favorites: Bool?
    @Persisted var rec: Bool?
    @Persisted var userName: String?
}
