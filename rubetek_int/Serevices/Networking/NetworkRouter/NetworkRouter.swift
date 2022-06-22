//
//  NetworkRouter.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation
import RealmSwift

final class NetworkRouter<T: Object> {

    func getDoors(complition: @escaping ([Door]?, Error?) -> Void) {
        let parsService = ParsDataServise<[Door]>(loadDataSevice: LoadDataService())
        parsService.fechRequest(from: DoorsEndPoint()) { doors, error in
            complition(doors, error)
        }
    }

    func getCams(complition: @escaping (Cameras?, Error?) -> Void) {
        let parsService = ParsDataServise<Cameras>(loadDataSevice: LoadDataService())
        parsService.fechRequest(from: CamsEndPoint()) { cameras, error in
            complition(cameras, error)
        }
    }
}
