//
//  NetworkManager.swift
//  FinQ
//
//  Created by 권대윤 on 8/30/26.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol: Sendable {
    func perform(api: APIRouter) async throws
    func perform<T: Decodable & Sendable>(api: APIRouter, model: T.Type) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol, Sendable {
    static let shared = NetworkManager()
    private init() { }
    
    func perform(api: APIRouter) async throws {
        let url = api.baseURL + api.path
        
        let response = await AF.request(url, method: api.method, parameters: api.parameters, headers: api.headers)
            .validate(statusCode: 200..<300)
            .serializingDecodable(Empty.self, emptyResponseCodes: [200, 204, 205])
            .response
        
        switch response.result {
        case .success:
            AppLogger.shared.log("\(api) 호출 응답 성공", level: .debug)
            
        case .failure(let error):
            AppLogger.shared.log("statusCode: \(response.response?.statusCode ?? 0), 에러 발생: \(error)", level: .error)
            throw error
        }
    }
    
    func perform<T: Decodable & Sendable>(api: APIRouter, model: T.Type) async throws -> T {
        let url = api.baseURL + api.path
        
        let response = await AF.request(url, method: api.method, parameters: api.parameters, headers: api.headers)
            .validate(statusCode: 200..<300)
            .serializingDecodable(model)
            .response
        
        switch response.result {
        case .success(let data):
            AppLogger.shared.log("\(api) 호출 응답 성공: \(data)", level: .debug)
            return data
            
        case .failure(let error):
            AppLogger.shared.log("statusCode: \(response.response?.statusCode ?? 0), 에러 발생: \(error)", level: .error)
            throw error
        }
    }
}
