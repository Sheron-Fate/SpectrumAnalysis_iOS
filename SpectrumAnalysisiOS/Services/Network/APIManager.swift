//
//  APIManager.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import Foundation

final class APIManager {
    private init() {}

    static let shared = APIManager()

    // Получение списка пигментов
    func getPigments(
        search: String? = nil,
        color: String? = nil,
        completion: @escaping (Result<[PigmentModel], APIError>) -> Void
    ) {
        var urlString = APIConstants.apiURL
        print("🌐 [APIManager] Запрос к: \(urlString)")

        // Добавляем query параметры
        var queryItems: [URLQueryItem] = []
        if let search = search, !search.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }
        if let color = color, !color.isEmpty {
            queryItems.append(URLQueryItem(name: "color", value: color))
        }

        if !queryItems.isEmpty {
            var components = URLComponents(string: urlString)
            components?.queryItems = queryItems
            urlString = components?.url?.absoluteString ?? urlString
            print("🌐 [APIManager] URL с параметрами: \(urlString)")
        }

        guard let url = URL(string: urlString) else {
            print("❌ [APIManager] Некорректный URL: \(urlString)")
            completion(.failure(.incorrectlyURL))
            return
        }

        print("📡 [APIManager] Отправка запроса к \(url.absoluteString)")
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("📥 [APIManager] Получен ответ")
            if let error = error {
                print("❌ [APIManager] Ошибка сети: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ [APIManager] Ответ не является HTTPURLResponse")
                DispatchQueue.main.async {
                    completion(.failure(.responseIsNil))
                }
                return
            }

            print("📊 [APIManager] Статус код: \(httpResponse.statusCode)")

            guard (200..<300).contains(httpResponse.statusCode) else {
                print("❌ [APIManager] Неуспешный статус код: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(.failure(.badStatusCode(httpResponse.statusCode)))
                }
                return
            }

            guard let data = data else {
                print("❌ [APIManager] Данные отсутствуют")
                DispatchQueue.main.async {
                    completion(.failure(.dataIsNil))
                }
                return
            }

            print("📦 [APIManager] Получено \(data.count) байт данных")

            do {
                let responseEntity = try JSONDecoder().decode(PigmentsResponseEntity.self, from: data)
                let models = responseEntity.pigments.map { $0.mapper }
                print("✅ [APIManager] Успешно декодировано \(models.count) пигментов")
                DispatchQueue.main.async {
                    completion(.success(models))
                }
            } catch {
                print("❌ [APIManager] Ошибка декодирования: \(error.localizedDescription)")
                if let dataString = String(data: data, encoding: .utf8) {
                    print("📄 [APIManager] Полученные данные: \(dataString.prefix(500))")
                }
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
            }
        }.resume()
    }

    // Получение детальной информации о пигменте
    func getPigment(id: Int, completion: @escaping (Result<PigmentModel, APIError>) -> Void) {
        let urlString = "\(APIConstants.apiURL)/\(id)"

        guard let url = URL(string: urlString) else {
            completion(.failure(.incorrectlyURL))
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.responseIsNil))
                }
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(.badStatusCode(httpResponse.statusCode)))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.dataIsNil))
                }
                return
            }

            do {
                let responseEntity = try JSONDecoder().decode(PigmentResponseEntity.self, from: data)
                let model = responseEntity.pigment.mapper
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.error(error)))
                }
            }
        }.resume()
    }
}
