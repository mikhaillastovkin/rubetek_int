//
//  Door.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation
import RealmSwift

class Door: Object, Codable {

    @Persisted(primaryKey: true) var id: Int?
    @Persisted var name: String?
    @Persisted var snapshot: String?
    @Persisted var room: String?
    @Persisted var favorites: Bool?
    @Persisted var userName: String?
}

extension Door: RealmItemProtocol {

    typealias RealmType = Door

    static func changeName(object: Door?, value: String?) throws {
        let realm = try Realm()
        try realm.write {
            object?.name = value
        }
    }

    static func changeFavorite(object: Door?) throws {
        let realm = try Realm()
        try realm.write {
            guard let value = object?.favorites
            else { return }
            object?.favorites = !value
        }
    }

    static func loadData(complition: @escaping () -> Void) {
        let parseServise = ParsDataServise<[Door]>(loadDataSevice: LoadDataService())
        parseServise.fechRequest(from: DoorsEndPoint()) { doors, error in
            guard let doors = doors
            else { return }
            try? Door.save(items: doors)
            complition()
        }

        struct DoorsEndPoint: EndPointProtocol {
            var method: HTTPMethod = .get
            var path: HTTPPath = .doors
            var parametrs: [String : Any] = [:]
        }
    }
}
