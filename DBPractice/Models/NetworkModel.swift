//
//  NetworkModel.swift
//  DBPractice
//
//  Created by Marcos on 18/9/23.
//

import Foundation
final class NetworkModel {
    
    private var token : String? {
        get{
            if let token = LocalDataModel.getToken(){
                return token
            }
            return nil
        }
        set{
            if let token = newValue {
                LocalDataModel.saveToken(token: token)
            }
            
        }
    }
    
    private let session: URLSession
    init(session: URLSession = .shared){
        self.session = session
        
    }
    
    
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    enum NetworkError: Error {
        case unknown
        case malformedUrl
        case decodingFailed
        case noData
        case StatusCode(code: Int?)
        case noToken
        case encodingFailed
    }
    
    func login(user: String, password: String, completion:@escaping (Result<String, NetworkError>) -> Void){
        var components = baseComponents
        components.path = "/api/auth/login"
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        //user:password
        let loginString = String(format:"%@:%@", user, password)
        
        
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.decodingFailed))
            return
        }
         //Transforma el string a base 64
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        
        //Configuramos la request
        
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) {[weak self] data, response, error in
            guard error == nil else{
                //Tal vez cambiarlo
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            let urlResponse = response as? HTTPURLResponse
            guard urlResponse?.statusCode == 200 else {
                completion(.failure(.StatusCode(code: urlResponse?.statusCode)))
                return
            }
            
            guard let  token = String(data: data, encoding: .utf8) else {
                completion(.failure(.noToken))
                return
            }
            
            completion(.success(token))
            self?.token = token
        }
        task.resume()
    }
    
    func getHeroes(completion: @escaping (Result<[Hero], NetworkError>) -> Void){
        
        var components = baseComponents
        components.path = "/api/heros/all"
        
        guard let url = components.url else {
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        //En este caso solicita todos los heroes se puede hacer refactor para obtener un solo heroe
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody =  urlComponents.query?.data(using: .utf8)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            guard let heroes = try? JSONDecoder().decode([Hero].self, from: data) else{
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(heroes))
            
        }
        task.resume()
    }
    
    // Mark: Get transformations
    func getTransformations(for hero: TableViewRepresentable, completion: @escaping ((Result<[Transformation], NetworkError>) -> Void) ){
        
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        //Comprobamos si components tiene url 
        guard let url = components.url else{
            completion(.failure(.malformedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        
//        let body = GetTransformationBody(id: hero.id)
        

        
//        guard let encodedBody = try? JSONEncoder().encode(body) else{
//            completion(.failure(.encodingFailed))
//            return
//        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name:"id", value: hero.id)]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpBody = urlComponents.query?.data(using: .utf8)
        
        
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            guard let transformations = try? JSONDecoder().decode([Transformation].self, from: data) else{
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(transformations))
        }
        
        task.resume()
    }
    
    
}
