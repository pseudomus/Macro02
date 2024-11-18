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
    @EnvironmentObject var storeKitManager: StoreKitManager
    
    @State private var screenSize: CGSize = .zero
    @State private var itemHeight: CGFloat = .zero
    @Namespace private var animation
    @State private var showingDeleteAlert = false
    @State private var essayToDelete: EssayResponse?

    
    var body: some View {
        
        CustomHeaderView(showCredits: true, title: "Redações", filters: [],
                         distanceContentFromTop: essayViewModel.isFirstTime ? 100 : 110,
                         showSearchBar: !essayViewModel.isFirstTime,
                         isScrollable: !essayViewModel.isFirstTime,
                         numOfItems: essayViewModel.essays.count,
                         itemsHeight: itemHeight) { shouldAnimate in
            
            VStack {
                correctionButton
                    .offset(y: shouldAnimate ? -250 : 0)
                    .animation(.easeInOut(duration: 0.3), value: shouldAnimate)
                
                if essayViewModel.isFirstTime {
                    firstTimeView
                } else {
                    essayListView
                }
            }
            .animation(.easeInOut(duration: 0.2), value: shouldAnimate)
            
            .padding(.bottom, 100) // para tabbar nao cobrir
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .getSize { size in
            screenSize = size
        }
        // MARK: - isLoading changes (fetch essays)
        .onChange(of: userViewModel.isLoading) { _, newValue in
            if !newValue {
                // quando o loading do usuário parar, faça o fetch se o usuário estiver disponível
                guard let user = userViewModel.user else { return }
                essayViewModel.fetchEssays(userId: "\(user.id)")
                Task { await storeKitManager.loadCreditBalance(userId: user.id) }

            }
        }
        .onChange(of: essayViewModel.shouldFetchEssays) { _, newValue in
            if newValue {
                guard let userId = userViewModel.user?.id else { return }
                // verifica se há um usuário logado
                essayViewModel.fetchEssays(userId: "\(userId)")
                
                // redefine shouldFetchEssays para evitar buscas repetidas
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
            if userViewModel.user != nil {
                navigate(.sheet)
            } else {
                navigate(.essays(.profile))
            }
            
        } label: {
            HStack(alignment: .bottom) {
                Text("Corrigir")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
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
            .background(Color(.colorBrandPrimary700))
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
            ForEach(self.essayViewModel.sortedMonths, id: \.self) { monthYear in
                Section(header: Text(monthYear)
                    .font(.headline)
                    .textCase(nil)
                    .foregroundStyle(.primary)
                ) {
                    if let essaysForMonth = self.essayViewModel.groupedEssays[monthYear]?.filter({ $0.isCorrected == true }) {
                        ForEach(essaysForMonth, id: \.id) { essay in
                            essayButton(for: essay)
                        }
                    }
                }
            }
        }
        .getSize { size in
            itemHeight = size.height
        }
    }


    
    private func essayButton(for essay: EssayResponse) -> some View {
        Button {
            if essay.isCorrected ?? false {
                navigate(.essays(.esssayCorrected(essayResponse: essay, text: essay.content!))) // redação pronta
            } else {
                guard let content = essay.content else { return }
                navigate(.essays(.esssayCorrected(text: content))) // redação carregando
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
}


#Preview {
    HomeEssayView()
        .environmentObject(UserViewModel())
        .environmentObject(StoreKitManager())
        .environmentObject(EssayViewModel())
}

