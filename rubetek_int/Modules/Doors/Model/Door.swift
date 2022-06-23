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

    static func loadData(complition: @escaping () -> Void) {
        let parseServise = ParsDataServise<[Door]>(loadDataSevice: LoadDataService())
        parseServise.fechRequest(from: DoorsEndPoint()) { doors, error in
            guard let doors = doors
            else { return }
            try? RealmService.save(items: doors)
            complition()
        }

        struct DoorsEndPoint: EndPointProtocol {
            var method: HTTPMethod = .get
            var path: HTTPPath = .doors
            var parametrs: [String : Any] = [:]
        }
    }
}
