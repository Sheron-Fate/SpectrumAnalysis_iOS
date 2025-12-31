//
//  PigmentCell.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import SwiftUI

struct PigmentCell: View {
    let pigment: PigmentModel

    // Формирование URL для изображения
    private var imageURL: URL? {
        guard let imageKey = pigment.imageKey, !imageKey.isEmpty else {
            print("⚠️ [PigmentCell] imageKey пустой для пигмента \(pigment.id)")
            return nil
        }
        let urlString = APIConstants.imageURL(imageKey: imageKey)
        print("🖼️ [PigmentCell] Пигмент \(pigment.id) - imageKey: '\(imageKey)', URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("❌ [PigmentCell] Не удалось создать URL из строки: \(urlString)")
            return nil
        }
        return url
    }

    var body: some View {
        HStack(spacing: 16) {
            // Изображение пигмента
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    // Placeholder при загрузке
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.appBorder.opacity(0.3))
                            .frame(width: 100, height: 100)
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onAppear {
                            print("✅ [PigmentCell] Изображение успешно загружено для пигмента \(pigment.id)")
                        }
                case .failure(let error):
                    // Fallback при ошибке
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.appBorder.opacity(0.3))
                            .frame(width: 100, height: 100)
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.appTextLight)
                    }
                    .onAppear {
                        print("❌ [PigmentCell] Ошибка загрузки изображения для пигмента \(pigment.id): \(error.localizedDescription)")
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 100)

            // Текстовая информация
            VStack(alignment: .leading, spacing: 8) {
                Text(pigment.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.appPrimary)
                    .lineLimit(2)

                Text(pigment.brief)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(.appTextLight)
                    .lineLimit(2)

                if let color = pigment.color {
                    HStack {
                        Circle()
                            .fill(colorFromString(color))
                            .frame(width: 12, height: 12)
                        Text(color)
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundColor(.appTextLight)
                    }
                }
            }

            Spacer()

            // Иконка перехода
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.appTextLight)
        }
        .padding()
        .background(Color.appWhite)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
    PigmentCell(pigment: .mockData)
        .padding()
        .background(Color.appBackground)
}
