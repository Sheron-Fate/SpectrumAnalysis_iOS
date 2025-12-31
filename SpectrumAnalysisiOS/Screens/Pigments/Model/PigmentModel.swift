//
//  PigmentModel.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import Foundation

struct PigmentModel: Identifiable {
    let id: Int
    var name: String
    var brief: String
    var description: String?
    var color: String?
    var specs: String?
    var spectrum: String?
    var imageKey: String?
    var createdAt: String?
}

// MARK: - Mock Data

extension PigmentModel {
    static let mockData = PigmentModel(
        id: 1,
        name: "Ультрамарин",
        brief: "Синий пигмент",
        description: "Описание ультрамарина",
        color: "Синий",
        specs: "Характеристики",
        imageKey: nil,
        createdAt: "2024-01-01T00:00:00Z"
    )
}

extension [PigmentModel] {
    static let mockData = (1...10).map {
        PigmentModel(
            id: $0,
            name: "Пигмент \($0)",
            brief: "Краткое описание пигмента \($0)",
            description: "Полное описание пигмента \($0)",
            color: ["Синий", "Красный", "Желтый"].randomElement(),
            specs: "Характеристики \($0)",
            imageKey: nil,
            createdAt: "2024-01-\(String(format: "%02d", $0))T00:00:00Z"
        )
    }
}
