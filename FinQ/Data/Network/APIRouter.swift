//
//  APIRouter.swift
//  FinQ
//
//  Created by 권대윤 on 8/30/26.
//

import Foundation
import Alamofire

enum APIRouter: Sendable {
    //MARK: - Auth
    case signUp(SignUpRequest)
}

extension APIRouter {
    var baseURL: String {
        return "http://finq-prod-public-alb-108906608.ap-northeast-2.elb.amazonaws.com/api/v1"
    }
    
    var path: String {
        switch self {
        case .signUp: return "/auth/sign-up"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .signUp:
            return [
                "Content-Type": "application/json"
            ]
        }
    }

    var encoding: any ParameterEncoding {
        switch self {
        case .signUp:
            return JSONEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .signUp(request):
            return [
                "email": request.email,
                "password": request.password,
                "nickname": request.nickname,
                "agreements": request.agreements.map { agreement -> Parameters in
                    return [
                        "agreementCode": agreement.agreementCode,
                        "version": agreement.version,
                        "agreed": agreement.agreed
                    ]
                }
            ]
        }
    }
}
