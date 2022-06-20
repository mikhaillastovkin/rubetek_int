//
//  ParsDataServise.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation

final class ParsDataServise<DataModel: Codable>: ParsDataServiseProtocol {

    private let loadDataService: LoadDataServiceProtocol

    init(loadDataSevice: LoadDataServiceProtocol) {
        self.loadDataService = loadDataSevice
    }

    func fechRequest(from: EndPointProtocol, complition: @escaping (DataModel?, Error?) -> Void) {
        loadDataService.loadRemoteData(from: from) { data, response, error in
            guard let data = data else {
                complition(nil, NetworkErrors.loadError)
                return
            }

            do {
                let parsData = try JSONDecoder().decode(Response<DataModel>.self, from: data)
                guard parsData.success
                else {
                    complition(nil, NetworkErrors.loadError)
                    return
                }
                complition(parsData.data, nil)
            } catch {
                complition(nil, NetworkErrors.parsError)
            }
        }
    }
}
