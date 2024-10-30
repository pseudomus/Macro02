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
    @EnvironmentObject var essayViewModel: EssayViewModel
    
    @State private var screenSize: CGSize = .zero
    @Namespace private var animation
    @State private var showingDeleteAlert = false
    @State private var essayToDelete: EssayResponse?

    
    // Filters
    var groupedEssays: [String: [EssayResponse]] {
        // Filtra as redações que possuem uma creationDate válida
        let essaysWithValidDate = essayViewModel.essays.filter { $0.creationDate != nil }

        // Agrupa as redações válidas
        let grouped = Dictionary(grouping: essaysWithValidDate, by: { monthYear(from: $0.creationDate!) })
        
        // Ordena as redações dentro de cada grupo
        return grouped.mapValues { $0.sorted(by: {
            // Utiliza um desempacotamento seguro com uma data padrão
            (dateFromString($0.creationDate!) ?? Date.distantPast) > (dateFromString($1.creationDate!) ?? Date.distantPast)
        }) }
    }

    var sortedMonths: [String] {
        // Ordena as chaves do dicionário baseado nas datas
        let sortedKeys = groupedEssays.keys.sorted {
            dateFromMonthYear($0)! > dateFromMonthYear($1)!
        }
        
        return sortedKeys
    }

    
    var body: some View {
        
        CustomHeaderView(title: "Redações", filters: [],
                         distanceContentFromTop: 110,
                         showSearchBar: true,
                         isScrollable: !essayViewModel.isFirstTime) { shouldAnimate in
            
            VStack {
                if !shouldAnimate {
                    correctionButton
                }
                
                if essayViewModel.isFirstTime {
                    firstTimeView
                } else {
                    essayListView
                }
            }
            // debug
            //.onAppear { essayViewModel.fetchEssays(userId: "101") }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .getSize { size in
            screenSize = size
        }
        .onAppear {
            if userViewModel.user == nil {
                essayViewModel.fetchEssays(userId: "105")
            }
        }
        // MARK: - isLoading changes (fetch essays)
        .onChange(of: userViewModel.isLoading) { _, newValue in
            if !newValue {
                // quando o loading do usuário parar, faça o fetch se o usuário estiver disponível
                guard let user = userViewModel.user else { return }
                essayViewModel.fetchEssays(userId: "\(user.id)")
            }
        }
        .onChange(of: essayViewModel.shouldFetchEssays) { _, newValue in
//            guard let user = userViewModel.user else { return }
//            if newValue {
//                essayViewModel.fetchEssays(userId: "\(user.id)")
//                essayViewModel.shouldFetchEssays = false
//            }
            if newValue {
                essayViewModel.fetchEssays(userId: "105")
                essayViewModel.shouldFetchEssays = false
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            deleteEssayAlert
        }

    }
    
    // MARK: - VIEWS
    private var correctionButton: some View {
        Button {
            navigate(.sheet)
        } label: {
            HStack(alignment: .bottom) {
                Text("Corrigir")
                    .font(.title3)
                    .foregroundStyle(.black)
                Spacer(minLength: screenSize.width / 2.7)
                if !essayViewModel.isFirstTime {
                    Image(.lapisinho)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .matchedGeometryEffect(id: "lapis", in: animation)
                }
            }
            .padding()
            .padding(.top, essayViewModel.isFirstTime ? screenSize.height / 9 : 0)
            .background(Color.gray.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 22)
            .padding(.bottom, 22)
        }
    }
    
    private var firstTimeView: some View {
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
    
    private var essayListView: some View {
        VStack(spacing: 15) {
            // REDAÇÃO CARREGANDO
            ForEach(essayViewModel.essays.filter { $0.isCorrected == false }, id: \.id) { temporaryEssay in
                essayButton(for: temporaryEssay)
            }
            
            // REDAÇÕES PRONTAS
            ForEach(sortedMonths, id: \.self) { monthYear in
                Section(header: Text(monthYear)
                    .font(.headline)
                    .textCase(nil)
                    .foregroundColor(.primary)
                ) {
                    ForEach(groupedEssays[monthYear]!.filter { $0.isCorrected == true }, id: \.id) { essay in
                        essayButton(for: essay)
                    }
                }
            }
        }
    }


    
    private func essayButton(for essay: EssayResponse) -> some View {
        Button {
            if essay.isCorrected ?? false {
                navigate(.essays(.esssayCorrected(essayResponse: essay, text: essay.content!))) // redação pronta
            } else {
                navigate(.essays(.esssayCorrected(text: essay.content!))) // redação carregando
            }
        } label: {
            CorrectedEssayCardView(
                title: essay.title,
                description: essay.theme,
                dayOfCorrection: essay.creationDate ?? "",
                isCorrected: essay.isCorrected ?? false
            )
        }
        .simultaneousGesture(LongPressGesture().onEnded { _ in
            showDeleteConfirmation(for: essay)
        })
    }

    
    // MARK: - ALERT
    private var deleteEssayAlert: Alert {
        Alert(title: Text("Deletar redação"),
              message: Text("Você tem certeza que deseja deletar essa redação?"),
              primaryButton: .destructive(Text("Deletar")) {
            if let essay = essayToDelete {
                essayViewModel.deleteEssay(withId: String(essay.id!))
            }
        },
              secondaryButton: .cancel())
    }

    // MARK: - FUNCTIONS
    private func showDeleteConfirmation(for essay: EssayResponse) {
        essayToDelete = essay
        showingDeleteAlert = true
    }
    
    private func monthYear(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Data Inválida"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM 'de' yyyy"
        outputFormatter.locale = Locale(identifier: "pt_BR")
        return outputFormatter.string(from: date).capitalized
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dateString)
    }
    
    private func dateFromMonthYear(_ monthYear: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM 'de' yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        return dateFormatter.date(from: monthYear)
    }
}


#Preview {
    HomeEssayView()
        .environmentObject(UserViewModel())
        .environmentObject(EssayViewModel())
}

