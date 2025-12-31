//
//  PigmentsList.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import SwiftUI

struct PigmentsList: View {
    @StateObject private var viewModel = PigmentsListViewModel()
    @State private var selectedColorFilter: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Фильтр по цвету
                    if !viewModel.availableColors.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                // Кнопка "Все"
                                ColorFilterButton(
                                    title: "Все",
                                    isSelected: selectedColorFilter == nil,
                                    action: {
                                        selectedColorFilter = nil
                                        viewModel.setColorFilter(nil)
                                    }
                                )

                                // Кнопки цветов
                                ForEach(viewModel.availableColors, id: \.self) { color in
                                    ColorFilterButton(
                                        title: color,
                                        isSelected: selectedColorFilter == color,
                                        action: {
                                            selectedColorFilter = color
                                            viewModel.setColorFilter(color)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 12)
                        .background(Color.appWhite)
                    }

                    // Список пигментов
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Spacer()
                    } else if viewModel.error != nil && viewModel.filteredPigments.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.appAccent)
                            Text("Ошибка загрузки данных")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.appPrimary)
                            if let error = viewModel.error {
                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundColor(.appTextLight)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            Button("Повторить") {
                                viewModel.fetchPigments()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.appSecondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredPigments.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.appTextLight)
                            Text("Пигменты не найдены")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.appPrimary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.filteredPigments) { pigment in
                                    NavigationLink(destination: PigmentDetails(pigmentId: pigment.id)) {
                                        PigmentCell(pigment: pigment)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Пигменты")
            .searchable(text: $viewModel.searchText, prompt: "Поиск по названию...")
            .onAppear {
                print("🟢 [PigmentsList] onAppear вызван, pigments.count = \(viewModel.pigments.count)")
                if viewModel.pigments.isEmpty {
                    print("🟢 [PigmentsList] Список пуст, вызываю fetchPigments()")
                    viewModel.fetchPigments()
                } else {
                    print("🟢 [PigmentsList] Список уже заполнен (\(viewModel.pigments.count) элементов)")
                }
            }
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.updateSearchText(newValue)
            }
        }
    }
}

// MARK: - Color Filter Button

struct ColorFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .appWhite : .appPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.appSecondary : Color.appBackground)
                .cornerRadius(20)
        }
    }
}

// MARK: - Preview

#Preview {
    PigmentsList()
}
