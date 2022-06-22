//
//  EndPointProtocol.swift
//  rubetek_int
//
//  Created by Михаил Ластовкин on 20.06.2022.
//

import Foundation

protocol EndPointProtocol {
    var scheme: String { get }
    var host: String { get }
    var method: HTTPMethod { get }
    var path: HTTPPath { get }
    var parametrs: [String: Any] { get set }
    var fullURL: URL? { get }
}

extension EndPointProtocol {
    var scheme: String {
        return "http"
    }
    var host: String {
        return "cars.cprogroup.ru"
    }

    var fullURL: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path.rawValue
        parametrs.forEach { urlComponents.queryItems?
                .append(URLQueryItem(name: $0.key,
                                     value: $0.value as? String))
        }
        return urlComponents.url
    }

    mutating func addParametr(key: String, value: Any) {
        parametrs[key] = value
    }
}
