//
//  UIFont.swift
//  Rovers
//
//  Created by air on 04.11.2022.
//

import UIKit

extension UIFont {
    
    static func getGillSansRegular(ofsize: CGFloat) -> UIFont {
        UIFont(name: "GillSans", size: ofsize) ?? UIFont()
    }
}
