//
//  APIRouter.swift
//  FinQ
//
//  Created by 권대윤 on 8/30/26.
//

import Foundation
import Alamofire

enum APIRouter {
    case sample
}

extension APIRouter {
    var baseURL: String {
        return "https://sample.com"
    }
    
    var path: String {
        switch self {
        case .sample: return "/sample/first"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sample:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default: return nil
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .sample:
            return nil
        }
    }
}
