//
//  RoverType.swift
//  Rovers
//
//  Created by air on 29.10.2022.
//

import UIKit

enum RoverType: Int, CaseIterable {
    case oppotunity
    case spirit
    case curiosity
    
    var roverSegmentImage: UIImage? {
        switch self {
        case .oppotunity: return UIImage(named: "oppotunity")
        case .spirit: return UIImage(named: "spirit")
        case .curiosity: return UIImage(named: "curiosity")
        }
    }
    
    var configName: String {
        switch self {
        case .oppotunity: return "Oppotunity"
        case .spirit: return "Spirit"
        case .curiosity: return "Curiosity"
        }
    }
    
    var urlName: String {
        switch self {
        case .oppotunity: return "oppotunity"
        case .spirit: return "spirit"
        case .curiosity: return "curiosity"
        }
    }
}
