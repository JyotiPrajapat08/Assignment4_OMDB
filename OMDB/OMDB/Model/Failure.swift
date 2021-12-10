//
//  Failure.swift
//  OMDB
//
//  Created by user193869 on 05/12/21.
//


import Foundation
public enum Failure:Error {
    case invalidURL
    case invalidSearchParameters
    case invalidResults(String)
    case invalidStatusCode(Int?)
}

extension Failure: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The requested URL is invalid.", comment: "")
        case .invalidSearchParameters:
            return NSLocalizedString("The URL parameters is invalid.", comment: "")
        case .invalidResults(let message):
            return NSLocalizedString(message, comment: "")
        case .invalidStatusCode(let message):
            return NSLocalizedString("Invalid HTTP status code:\(message ?? -1)", comment: "")
        }
    }
}
