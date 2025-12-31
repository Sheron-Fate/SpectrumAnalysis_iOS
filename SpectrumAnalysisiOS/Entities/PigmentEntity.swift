//
//  PigmentEntity.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import Foundation

// Entity для декодирования ответа API со списком пигментов
struct PigmentsResponseEntity: Decodable {
    var pigments: [PigmentEntity]
    var count: Int
}

// Entity для декодирования ответа API с одним пигментом
struct PigmentResponseEntity: Decodable {
    var pigment: PigmentEntity
}

// Entity для одного пигмента из API
struct PigmentEntity: Decodable {
    var id: Int
    var name: String
    var brief: String
    var description: String?
    var color: String?
    var specs: String?
    var spectrum: String?
    var imageKey: String?
    var createdAt: String?

    // Маппинг JSON ключей (snake_case) в Swift свойства (camelCase)
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case brief
        case description
        case color
        case specs
        case spectrum
        case imageKey = "image_key"
        case createdAt = "created_at"
    }
}

// MARK: - Mapper

extension PigmentEntity {
    var mapper: PigmentModel {
        PigmentModel(
            id: id,
            name: name,
            brief: brief,
            description: description,
            color: color,
            specs: specs,
            spectrum: spectrum,
            imageKey: imageKey,
            createdAt: createdAt
        )
    }
}
