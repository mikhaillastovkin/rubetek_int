//
//  LoadDataServiceProtocol.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation

public typealias NetworkComplition = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol LoadDataServiceProtocol {
    func loadRemoteData(from: EndPointProtocol, complition: @escaping NetworkComplition)
}
