//
//  HomeEssayView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 09/10/24.
//

import SwiftUI


struct HomeEssayView: View {
    @Environment(\.navigate) var navigate
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var viewModel: HomeEssayViewModel = HomeEssayViewModel()

    @State var screenSize: CGSize = .zero
    @Namespace var animation

    var groupedEssays: [String: [EssayResponse]] {
        Dictionary(grouping: viewModel.essays, by: { monthYear(from: $0.creationDate!) })
    }

    var body: some View {
        VStack {
            CustomHeaderView(title: "Redações", filters: ["Oi"],
                             distanceContentFromTop: 110,
                             showSearchBar: true,
                             isScrollable: !viewModel.isFirstTime) { shouldAnimate in
                
                VStack {
                    if !shouldAnimate {
                        Button {
                            navigate(.essays(.correct))
                        } label: {
                            HStack(alignment: .bottom) {
                                Text("Corrigir")
                                    .font(.title3)
                                    .foregroundStyle(.black)
                                Spacer(minLength: screenSize.width / 2.7)
                                if !viewModel.isFirstTime {
                                    Image(.lapisinho)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .matchedGeometryEffect(id: "lapis", in: animation)
                                }
                            }
                            .padding()
                            .padding(.top, viewModel.isFirstTime ? screenSize.height / 9 : 0)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 10))
                            .padding(.horizontal, 22)
                            .padding(.bottom, 22)
                        }
                    }

                    if viewModel.isFirstTime {
                        ZStack {
                            Image(.lapisinho)
                                .offset(x: -screenSize.width / 2.4)
                                .matchedGeometryEffect(id: "lapis", in: animation)
                            
                            VStack {
                                HStack(spacing: 10) {
                                    Text("--")
                                    Text("Oie! Tá na hora de corrigir sua primeira redação, com o tempo vamos ver seu histórico e evolução, vamos lá?")
                                        .font(.subheadline)
                                }
                                .padding(.leading, screenSize.height / 7)
                                .padding(.trailing, screenSize.height / 20)
                                .offset(y: -screenSize.height / 25)
                            }
                        }
                    }
                    // LISTAR REDAÇÕES
                    else {
                        VStack(spacing: 15) {
                            ForEach(groupedEssays.keys.sorted(), id: \.self) { monthYear in
                                Section(header:
                                    Text(monthYear)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                ) {
                                    ForEach(groupedEssays[monthYear]!, id: \.id) { essay in
                                        Button {
                                            navigate(.essays(.esssayCorrected(essayResponse: essay, text: essay.content!)))
                                        } label: {
                                            CorrectedEssayCardView(
                                                title: essay.title,
                                                description: essay.theme,
                                                dayOfCorrection: essay.creationDate!
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .getSize { size in
            screenSize = size
        }
        .onChange(of: userViewModel.user?.id) { oldValue, newValue in
            guard let user = userViewModel.user else { return }
            viewModel.fetchEssays(id: "\(user.id)")
        }
        // MARK: - DEBUG
        .onAppear { viewModel.fetchEssays(id: "101") }
    }

    private func monthYear(from dateString: String) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = dateFormatter.date(from: dateString) else {
            return "Data Inválida"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM 'de' yyyy" // "Setembro de 2024"
        outputFormatter.locale = Locale(identifier: "pt_BR")
        //outputFormatter.locale = Locale.current
        return outputFormatter.string(from: date).capitalized
    }
}



#Preview {
    HomeEssayView()
        .environmentObject(UserViewModel())
}

