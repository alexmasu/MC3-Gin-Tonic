//
//  String+localized.swift
//  MC3-Gin-Tonic
//
//  Created by Alessandro Masullo on 22/02/22.
//

import Foundation



extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
