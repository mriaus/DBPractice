//
//  Transformation.swift
//  DBPractice
//
//  Created by Marcos on 18/9/23.
//

import Foundation


//Dejamos decodable ya que no vamos a necesitar que se pueda codificar
struct Transformation: Decodable, TableViewRepresentable{
    
    let id: String
    let name: String
    let description: String
    let photo: URL
}
