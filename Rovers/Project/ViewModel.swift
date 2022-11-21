//
//  ViewModel.swift
//  Rovers
//
//  Created by air on 29.10.2022.
//

import Foundation
import SafariServices

protocol ViewModelProtocol {
    var controller: ViewController! { get set }
    
    func openRoverMissingPage(_ rover: RoverType)
}

final class ViewModel: ViewModelProtocol {
    var controller: ViewController!
    
    func openRoverMissingPage(_ rover: RoverType) {
        controller.openMission(with: ConfigurationService(with: rover).missionPage)
    }
}

