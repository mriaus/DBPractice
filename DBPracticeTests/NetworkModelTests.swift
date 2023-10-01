//
//  NetwokrModelTests.swift
//  DBPracticeTests
//
//  Created by Marcos on 19/9/23.
//

import XCTest
@testable import DBPractice

final class NetworkModelTests: XCTestCase {
    //Subget under test
    private var sut: NetworkModel!
    
    
    //Se ejecuta una vez por metodo
    override func setUp() {
        super.setUp()
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MOCKURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = NetworkModel(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testLogin(){
        let expectedToken: String = "token"
        let user: String = "user"
        let password: String = "password"
        
        MOCKURLProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", user, password)
            let loginData = loginString.data(using: .utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LoginString)")
            
            let data = try XCTUnwrap(expectedToken.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string:"https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"])
            )
            
            
            return (response, data)
        }
        
        let expectation = expectation(description: "Login success")
        
        sut.login(user: user, password: password) { result in
            guard case let .success(token) = result else {
                XCTFail("Expected succes but received \(result)")
                return
            }
            XCTAssertEqual(token, expectedToken)
            expectation.fulfill()
        }
        wait(for: [expectation])
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

