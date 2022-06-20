//
//  NetworkRouter.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation

final class NetworkRouter {

    func getDoors(complition: @escaping ([Door]?, Error?) -> Void) {
        let parsService = ParsDataServise<[Door]>(loadDataSevice: LoadDataService())
        parsService.fechRequest(from: DoorsEndPoint()) { doors, error in
            complition(doors, error)
        }
    }

    func getCams(complition: @escaping ([Camera]?, Error?) -> Void) {
        let parsService = ParsDataServise<Cameras>(loadDataSevice: LoadDataService())
        parsService.fechRequest(from: CamsEndPoint()) { cameras, error in
            complition(cameras?.cameras, error)
        }
    }
}
