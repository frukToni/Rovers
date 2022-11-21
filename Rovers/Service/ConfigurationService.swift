//
//  ConfigurationService.swift
//  Rovers
//
//  Created by air on 10.11.2022.
//

import UIKit

final class ConfigurationService {
    let apiKey: String
    let missionPage: URL
    let photo: URL

    init(with rover: RoverType) {
        var format = PropertyListSerialization.PropertyListFormat.xml

        guard let path = Bundle.main.path(forResource: rover.configName, ofType: "plist"),
              let file = FileManager.default.contents(atPath: path),
              let config = try? PropertyListSerialization.propertyList(
                from: file,
                options: .mutableContainersAndLeaves,
                format: &format) as? [String: Any] else { fatalError("plist not found") }
        
        self.apiKey = config["apiKey"] as! String
        
        let urls = config["urls"] as! [String: Any]
        self.missionPage = getURL(from: urls["missionPage"] as? [String: Any] ?? urls)
        self.photo = getURL(from: urls["photo"] as? [String: Any] ?? urls)
        
        func getURL(from dict: [String: Any]) -> URL {
            var components = URLComponents()
            components.scheme = dict["scheme"] as? String
            components.host = dict["host"] as? String
            components.path = (dict["path"] as? String) ?? ""
            
            let version = dict["version"] as! String
            if !version.isEmpty {
                components.path += "\(version)"
            }
            
            return components.url!
        }
    }
}
