//
//  PigmentsListViewModel.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import Foundation

final class PigmentsListViewModel: ObservableObject {
    @Published var pigments: [PigmentModel] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil

    // Фильтры
    @Published var searchText: String = ""
    @Published var selectedColor: String? = nil

    // Доступные цвета для фильтрации
    let availableColors: [String] = ["Синий", "Красный", "Желтый", "Черный", "Белый", "Зеленый"]

    // Отфильтрованные пигменты
    var filteredPigments: [PigmentModel] {
        var filtered = pigments

        // Фильтрация по поисковому запросу
        if !searchText.isEmpty {
            let searchLower = searchText.lowercased()
            filtered = filtered.filter { pigment in
                (pigment.name.lowercased().contains(searchLower) ||
                 pigment.brief.lowercased().contains(searchLower))
            }
        }

        // Фильтрация по цвету
        if let selectedColor = selectedColor, !selectedColor.isEmpty {
            filtered = filtered.filter { pigment in
                (pigment.color?.lowercased().contains(selectedColor.lowercased()) ?? false)
            }
        }

        return filtered
    }

    // Загрузка пигментов из API
    func fetchPigments() {
        print("🔵 [ViewModel] fetchPigments() вызван")
        isLoading = true
        error = nil

        APIManager.shared.getPigments(search: searchText.isEmpty ? nil : searchText,
                                     color: selectedColor) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let data):
                print("✅ [ViewModel] Успешно получено \(data.count) пигментов")
                self.pigments = data
                self.error = nil
            case .failure(let apiError):
                print("❌ [ViewModel] Ошибка: \(apiError.localizedDescription)")
                self.error = apiError.localizedDescription
                // При ошибке можно использовать mock данные для демонстрации
                self.pigments = .mockData
            }
        }
    }

    // Обновление поискового запроса
    func updateSearchText(_ text: String) {
        searchText = text
        // Можно добавить debounce для поиска в реальном времени
    }

    // Установка фильтра по цвету
    func setColorFilter(_ color: String?) {
        selectedColor = color
    }

    // Сброс фильтров
    func resetFilters() {
        searchText = ""
        selectedColor = nil
        fetchPigments()
    }
}
