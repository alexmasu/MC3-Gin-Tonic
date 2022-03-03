//
//  UserDefaults+contains.swift
//  MC3-Gin-Tonic
//
//  Created by Alessandro Masullo on 03/03/22.
//

import Foundation

extension UserDefaults {
    func contains(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
