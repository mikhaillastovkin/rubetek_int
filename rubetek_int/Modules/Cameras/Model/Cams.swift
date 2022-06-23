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
    var room: [String]
}

class Camera: Object, Codable {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var name: String?
    @Persisted var snapshot: String?
    @Persisted var room: String?
    @Persisted var favorites: Bool?
    @Persisted var rec: Bool?
    @Persisted var userName: String?
}

extension Camera: RealmItemProtocol {

    static func loadData(complition: @escaping () -> Void) {
        let parseServise = ParsDataServise<Cameras>(loadDataSevice: LoadDataService())
        parseServise.fechRequest(from: CamsEndPoint()) { cameras, error in
            guard let cameraArray = cameras?.cameras
            else { return }
            try? RealmService.save(items: cameraArray)
            complition()
        }

        struct CamsEndPoint: EndPointProtocol {
            var method: HTTPMethod = .get
            var path: HTTPPath = .cams
            var parametrs: [String : Any] = [:]
        }
    }
}
