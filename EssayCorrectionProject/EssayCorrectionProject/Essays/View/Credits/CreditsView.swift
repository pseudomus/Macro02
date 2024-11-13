//
//  CreditsView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//


import SwiftUI
import StoreKit

struct CreditsView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager
    @Environment(\.navigate) var navigate
    
    @State private var isLoading = false
    @State private var purchaseError: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: - LOJA
                VStack(alignment: .leading, spacing: 5) {
                    Text("Loja")
                        .font(.title)
                        .padding(.horizontal)
                        .fontWeight(.semibold)
                    
                    Text("Compre créditos para corrigir suas redações")
                        .padding(.horizontal)
                        .fontWeight(.regular)
                    
                    // LISTA DE BOTOES DE CRÉDITO
                    ScrollView(.horizontal) {
                        ForEach(storeKitManager.products) { product in
                            Button {
                                _ = Task<Void, Never> {
                                    do {
                                        try await storeKitManager.purchase(product)
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                            } label: {
                                BuyCreditsButton(numberOfCredits: 1, price: 2.90)
                                    .padding(.bottom)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 20)
                
                Text("OU")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.colorBrandPrimary500)
                    .padding(.vertical, 40)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // MARK: - TRILHA DE ANÚNCIOS
                VStack(alignment: .leading, spacing: 5) {
                    Text("Trilha de anúncios")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("Assista 11 anúncios e ganhe 1 crédito")
                        .fontWeight(.regular)
                    SnakeButtonGridView()
                }
                .padding(.horizontal)
                
                // COLOCAR NO ÍNICIO DO APP
                .task {
                    await storeKitManager.updatePurchasedProducts()
                }
                .task {
                    _ = Task<Void, Never> {
                        do {
                            try await storeKitManager.loadProducts()
                        } catch {
                            purchaseError = "Erro ao carregar produtos. Tente novamente mais tarde."
                        }
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Image(systemName: "square.3.stack.3d")
                        Text("\(storeKitManager.creditBalance) \(storeKitManager.creditBalance == 1 ? "crédito" : "créditos")")
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color(.colorBrandPrimary700))
                    .clipShape(.capsule)
                    //.padding(.bottom, 10)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigate(.exitSheet)
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .fontWeight(.light)
                            .frame(width: 28)
                            .foregroundStyle(.colorBrandPrimary700)
                            .padding(.trailing, 5)
                    }
                }
            }
            .toolbarBackground(Color(.systemBackground))
        }
    }
}

#Preview {
    CreditsView()
        .environmentObject(StoreKitManager())
}
