//
//  PigmentDetails.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import SwiftUI

struct PigmentDetails: View {
    let pigmentId: Int
    @State private var pigment: PigmentModel?
    @State private var isLoading: Bool = true
    @State private var error: String? = nil

    // Формирование URL для изображения
    private var imageURL: URL? {
        guard let imageKey = pigment?.imageKey, !imageKey.isEmpty else {
            print("⚠️ [PigmentDetails] imageKey пустой")
            return nil
        }
        let urlString = APIConstants.imageURL(imageKey: imageKey)
        print("🖼️ [PigmentDetails] imageKey: '\(imageKey)', URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("❌ [PigmentDetails] Не удалось создать URL из строки: \(urlString)")
            return nil
        }
        return url
    }

    // Форматирование даты
    private var formattedDate: String? {
        guard let createdAt = pigment?.createdAt else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: createdAt) ?? ISO8601DateFormatter().date(from: createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .long
            displayFormatter.locale = Locale(identifier: "ru_RU")
            return displayFormatter.string(from: date)
        }
        return nil
    }

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            } else if let error = error {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.appAccent)
                    Text("Ошибка загрузки")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.appPrimary)
                    Text(error)
                        .font(.system(size: 14))
                        .foregroundColor(.appTextLight)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
            } else if let pigment = pigment {
                VStack(alignment: .leading, spacing: 24) {
                    // Изображение
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.appBorder.opacity(0.3))
                                ProgressView()
                            }
                            .aspectRatio(1, contentMode: .fit)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .onAppear {
                                    print("✅ [PigmentDetails] Изображение успешно загружено")
                                }
                        case .failure(let error):
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.appBorder.opacity(0.3))
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundColor(.appTextLight)
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .onAppear {
                                print("❌ [PigmentDetails] Ошибка загрузки изображения: \(error.localizedDescription)")
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }

                    // Название
                    Text(pigment.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.appPrimary)

                    // Краткое описание
                    Text(pigment.brief)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.appSecondary)

                    Divider()

                    // Полное описание
                    if let description = pigment.description, !description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Описание")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.appPrimary)
                            Text(description)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.appText)
                        }
                    }

                    // Цвет
                    if let color = pigment.color {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Цвет")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.appPrimary)
                            HStack {
                                Circle()
                                    .fill(colorFromString(color))
                                    .frame(width: 20, height: 20)
                                Text(color)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .foregroundColor(.appText)
                            }
                        }
                    }

                    // Характеристики
                    if let specs = pigment.specs, !specs.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Характеристики")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.appPrimary)
                            Text(specs)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.appText)
                        }
                    }

                    // Дата создания
                    if let date = formattedDate {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Добавлен")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.appPrimary)
                            Text(date)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .foregroundColor(.appText)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadPigment()
        }
    }

    private func loadPigment() {
        isLoading = true
        error = nil

        APIManager.shared.getPigment(id: pigmentId) { result in
            isLoading = false

            switch result {
            case .success(let data):
                self.pigment = data
                self.error = nil
            case .failure(let apiError):
                self.error = apiError.localizedDescription
            }
        }
    }

    // Вспомогательная функция для преобразования строки цвета в Color
    private func colorFromString(_ colorString: String) -> Color {
        let lowercased = colorString.lowercased()
        switch lowercased {
        case "синий", "blue":
            return .blue
        case "красный", "red":
            return .red
        case "желтый", "yellow":
            return .yellow
        case "черный", "black":
            return .black
        case "белый", "white":
            return .gray
        case "зеленый", "green":
            return .green
        default:
            return .gray
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PigmentDetails(pigmentId: 1)
    }
}
