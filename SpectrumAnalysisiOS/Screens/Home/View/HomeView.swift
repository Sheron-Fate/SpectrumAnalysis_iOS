//
//  HomeView.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Заголовок
                VStack(spacing: 16) {
                    Text("Спектроскопический анализ")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.appPrimary)
                        .multilineTextAlignment(.center)

                    Text("фрагмента живописи")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.appSecondary)
                }
                .padding(.top, 40)

                // Описание
                VStack(spacing: 12) {
                    Text("Добро пожаловать в систему спектроскопического анализа!")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.appPrimary)
                        .multilineTextAlignment(.center)

                    Text("Здесь вы можете изучить пигменты и провести анализ фрагментов живописи с использованием современных технологий спектроскопии.")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.appTextLight)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 20)

                // Декоративный элемент или иконка (опционально)
                Image(systemName: "paintpalette.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.appSecondary)
                    .padding(.top, 20)

                Spacer(minLength: 40)
            }
            .padding()
        }
        .background(Color.appBackground)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
