//
//  LocalDataModel.swift
//  DBPractice
//
//  Created by Marcos on 26/9/23.
//

import Foundation

struct LocalDataModel {
    
    private static let TOKEN = "token"
    
    private static let userDefaults = UserDefaults.standard
    
    static func getToken() -> String? {
        userDefaults.string(forKey: TOKEN)
    }
    
    static func saveToken(token: String){
        userDefaults.set(token, forKey: TOKEN)
    }
    
    static func deleteToken(){
        userDefaults.removeObject(forKey: TOKEN)
    }
}
