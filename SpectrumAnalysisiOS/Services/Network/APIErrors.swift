//
//  APIErrors.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import Foundation

enum APIError: LocalizedError {
    case badParameters
    case dataIsNil
    case badStatusCode(Int)
    case error(Error)
    case responseIsNil
    case incorrectlyURL

    var errorDescription: String? {
        switch self {
        case .badParameters:
            return "Некорректные параметры запроса"
        case .dataIsNil:
            return "Данные отсутствуют"
        case .responseIsNil:
            return "Ответ отсутствует"
        case .badStatusCode(let code):
            return "Ошибка сервера: \(code)"
        case .error(let error):
            return error.localizedDescription
        case .incorrectlyURL:
            return "Некорректный URL"
        }
    }
}
