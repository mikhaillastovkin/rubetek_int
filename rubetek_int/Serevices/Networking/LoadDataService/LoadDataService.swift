//
//  LoadDataService.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation

final class LoadDataService: LoadDataServiceProtocol {

    func loadRemoteData(from: EndPointProtocol, complition: @escaping NetworkComplition) {
        guard let currentUrl = from.fullURL
        else {
            complition(nil, nil, NetworkErrors.urlError)
            return
        }

        let session = URLSession.shared
        var request = URLRequest(url: currentUrl)
        request.httpMethod = from.method.rawValue

        let task = session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode < 400,
                  error == nil
            else {
                complition(nil, nil, NetworkErrors.loadError)
                return
            }
            DispatchQueue.main.async {
                complition(data, response, nil)
            }
        }
        task.resume()
    }
}
