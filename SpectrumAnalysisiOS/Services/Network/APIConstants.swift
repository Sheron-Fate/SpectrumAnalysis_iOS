//
//  APIConstants.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import Foundation

struct APIConstants {
    // IP адрес сервера в локальной сети (реальный IP Mac в сети)
    static let baseURL = "http://192.168.1.24:8080"
    static let apiPath = "/api/pigments"

    // Полный URL для API
    static var apiURL: String {
        baseURL + apiPath
    }

    // URL для получения изображения через прокси API
    static func imageURL(imageKey: String) -> String {
        // Используем прокси через API вместо прямого доступа к MinIO
        // Убираем начальный слеш, если он есть
        let trimmedKey = imageKey.hasPrefix("/") ? String(imageKey.dropFirst()) : imageKey
        // Кодируем каждый компонент пути отдельно
        let components = trimmedKey.split(separator: "/").map { component in
            component.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? String(component)
        }
        let encodedKey = components.joined(separator: "/")
        let urlString = baseURL + "/api/images/" + encodedKey
        print("🔗 [APIConstants] Формирую URL изображения: imageKey='\(imageKey)' -> URL='\(urlString)'")
        return urlString
    }
}
