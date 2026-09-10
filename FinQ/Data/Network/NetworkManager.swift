//
//  NetworkManager.swift
//  FinQ
//
//  Created by 권대윤 on 8/30/26.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol: Sendable {
    func perform<Response: Decodable & Sendable>(api: APIRouter, responseType: Response.Type) async throws -> Response
}

final class NetworkManager: NetworkManagerProtocol, Sendable {
    static let shared = NetworkManager()
    private let authInterceptor = AuthInterceptor()
    private init() { }
    
    func perform<Response: Decodable & Sendable>(api: APIRouter, responseType: Response.Type) async throws -> Response {
        let url = api.baseURL + api.path
        
        let response = await AF.request(url, method: api.method, parameters: api.parameters, encoding: api.encoding, headers: api.headers, interceptor: api.requiresAuthorization ? authInterceptor : nil)
            .validate(statusCode: 200..<300)
            .serializingDecodable(responseType)
            .response
        
        switch response.result {
        case .success(let data):
            AppLogger.shared.log("\(api.method.rawValue) \(api.path) 호출 응답 성공", level: .debug)
            #if DEBUG
            AppLogger.shared.log("\(data)", level: .debug)
            #endif
            return data
            
        case let .failure(error):
            if case let .requestRetryFailed(retryError, _) = error { throw retryError }
            if case let .requestAdaptationFailed(underlyingError) = error { throw underlyingError }

            let responseBody = response.data.flatMap {
                String(data: $0, encoding: .utf8)
            }

            let requestURL = response.request?.url?.absoluteString ?? url
            let requestMethod = response.request?.httpMethod ?? api.method.rawValue
            let requestJSON = prettyJSON(parameters: api.parameters)

            #if DEBUG
            AppLogger.shared.log(
                """
                requestURL: \(requestURL)
                requestMethod: \(requestMethod)
                requestParameters:
                \(requestJSON)
                statusCode: \(response.response?.statusCode ?? 0)
                responseBody:
                \(responseBody ?? "없음")
                error: \(error)
                """,
                level: .error
            )
            #endif

            if let statusCode = response.response?.statusCode,
               (500..<600).contains(statusCode) {
                throw APIErrorResponse(message: "일시적인 오류가 발생했어요.\n잠시 후 다시 시도해 주세요.")
            }
            
            if let statusCode = response.response?.statusCode,
               !(200..<300).contains(statusCode),
               let data = response.data,
               let serverError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw serverError
            }
            throw error
        }
    }
    
    private func prettyJSON(parameters: Parameters?) -> String {
        guard let parameters else {
            return "없음"
        }

        guard JSONSerialization.isValidJSONObject(parameters),
              let data = try? JSONSerialization.data(
                  withJSONObject: parameters,
                  options: [.prettyPrinted, .sortedKeys]
              ),
              let json = String(data: data, encoding: .utf8)
        else {
            return String(describing: parameters)
        }

        return json
    }
}
