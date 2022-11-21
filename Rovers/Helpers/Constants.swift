//
//  Constants.swift
//  Rovers
//
//  Created by air on 05.11.2022.
//

import UIKit

enum Constants {
    enum PrimaryDateFormatter {
        static let request: DateFormatter = {
           let date = DateFormatter()
            date.dateFormat = "yyyy-MM-dd"
            return date
        }()
    }
}

