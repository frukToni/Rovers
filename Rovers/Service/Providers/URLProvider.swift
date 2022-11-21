//
//  URLProvider.swift
//  Rovers
//
//  Created by air on 14.11.2022.

import Foundation

protocol URLProviderProtocol {
    var url: URL { get }
}

final class URLProvider: URLProviderProtocol {
    var url: URL

    init(endpoint: NasaApiEndPoint) {
        url = endpoint.url
    }
}

enum NasaApiEndPoint {
    case manifest(rover: RoverType)
    case photosBySol(rover: RoverType, sol: Int, page: Int)
    case photosByData(rover: RoverType, date: Date, page: Int)
}

extension NasaApiEndPoint: URLProviderProtocol {
    func config(for rover: RoverType) -> ConfigurationService {
        ConfigurationService(with: rover)
    }

    var url: URL {
        switch self {
        case .manifest(let rover):
            let config = ConfigurationService(with: rover)
            var resultUrl = config.missionPage.appending(path: "/manifest/\(rover.urlName)")
            resultUrl.append(queryItems: [
                .init(name: "api_key", value: config.apiKey)
            ])
            return resultUrl

        case .photosByData(let rover, let date, let page):
            let dateStr = Constants.PrimaryDateFormatter.request.string(from: date)

            let config = ConfigurationService(with: rover)
            var resultUrl = config.missionPage.appending(path: "/rovers/\(rover.urlName)/photos")
            resultUrl.append(queryItems: [
                .init(name: "earth_date", value: dateStr),
                .init(name: "page", value: String(page)),
                .init(name: "api_key", value: config.apiKey)
            ])
            return resultUrl

        case .photosBySol(rover: let rover, sol: let sol, page: let page):
            let config = ConfigurationService(with: rover)
            var resultUrl = config.missionPage.appending(path: "/rovers/\(rover.urlName)/photos")
            resultUrl.append(queryItems: [
                .init(name: "sol", value: String(sol)),
                .init(name: "page", value: String(page)),
                .init(name: "api_key", value: config.apiKey)
            ])
            return resultUrl
        }
    }
}
