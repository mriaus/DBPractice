//
//  NetwokrModelTests.swift
//  DBPracticeTests
//
//  Created by Marcos on 19/9/23.
//

import XCTest
@testable import DBPractice

final class NetworkModelTests: XCTestCase {
    private var sut: NetworkModel!
    
    
    //Se ejecuta una vez por metodo
    override func setUp() {
        super.setUp()
        
    }
    
}

//Mirar OHHTTPStubs
//Mock para testear con llamadas
final class MOCKURLProtocol: URLProtocol {
    static var error: NetworkModel.NetworkError?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MOCKURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MOCKURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

