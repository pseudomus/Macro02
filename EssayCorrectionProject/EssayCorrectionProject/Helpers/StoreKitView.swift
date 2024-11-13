//
//  StoreKitView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 03/11/24.
//

//import Foundation
//import StoreKit
//import SwiftUI
//
//typealias PurchaseResult = Product.PurchaseResult
//typealias TransactionListener = Task<Void, Error>
//
//enum CreditsError: LocalizedError {
//    case failedVerification
//    case system(Error)
//    
//    var errorDescription: String? {
//        switch self {
//        case .failedVerification:
//            return "Failed to verify transaction"
//        case .system(let err):
//            return err.localizedDescription
//        }
//    }
//}
//
//enum CreditsAction: Equatable {
//    case successful
//    case failed(CreditsError)
//    
//    var error: CreditsError? {
//        if case .failed(let err) = self {
//            return err
//        }
//        return nil
//    }
//    
//    static func == (lhs: CreditsAction, rhs: CreditsAction) -> Bool {
//        switch (lhs, rhs) {
//        case (.successful, .successful):
//            return true
//        case (let .failed(lhsErr), let .failed(rhsErr)):
//            return lhsErr.localizedDescription == rhsErr.localizedDescription
//        default:
//            return false
//        }
//    }
//}
//
//@MainActor
//final class CreditsStore: ObservableObject {
//    @Published private(set) var product: Product?
//    @Published private(set) var action: CreditsAction? {
//        didSet {
//            hasError = action != .successful
//        }
//    }
//    @Published var hasError = false
//    @Published var isPurchased = false  // Novo estado para verificar compra
//    
//    private var transactionListener: TransactionListener?
//    private let productId = "credits_10"
//    
//    init() {
//        transactionListener = configureTransactionListener()
//        Task {
//            await fetchProduct()
//            await checkIfPurchased()  // Verifica o status de compra ao iniciar
//        }
//    }
//    
//    deinit {
//        transactionListener?.cancel()
//    }
//    
//    func purchase() async {
//        guard let product = product else { return }
//        
//        do {
//            let result = try await product.purchase()
//            try await handlePurchase(result)
//        } catch {
//            action = .failed(.system(error))
//            print("Purchase error: \(error)")
//        }
//    }
//    
//    func reset() {
//        action = nil
//    }
//}
//
//private extension CreditsStore {
//    
//    func configureTransactionListener() -> TransactionListener {
//        Task { [weak self] in
//            do {
//                for await result in Transaction.updates {
//                    let transaction = try self?.checkVerified(result)
//                    self?.action = .successful
//                    self?.isPurchased = true  // Atualiza status de compra
//                    await transaction?.finish()
//                }
//            } catch {
//                self?.action = .failed(.system(error))
//            }
//        }
//    }
//    
//    func fetchProduct() async {
//        do {
//            let products = try await Product.products(for: [productId])
//            product = products.first
//        } catch {
//            action = .failed(.system(error))
//            print("Failed to fetch products: \(error)")
//        }
//    }
//    
//    func handlePurchase(_ result: PurchaseResult) async throws {
//        switch result {
//        case .success(let verification):
//            let transaction = try checkVerified(verification)
//            action = .successful
//            isPurchased = true  // Atualiza status de compra
//            await transaction.finish()
//        case .pending:
//            print("Purchase pending.")
//        case .userCancelled:
//            print("Purchase cancelled by user.")
//        default:
//            print("Unexpected purchase result.")
//        }
//    }
//    
//    // Verifica se o usuário já possui a compra
//    func checkIfPurchased() async {
//        for await result in Transaction.currentEntitlements {
//            if let transaction = try? checkVerified(result), transaction.productID == productId {
//                isPurchased = true
//                break
//            }
//        }
//    }
//    
//    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
//        switch result {
//        case .unverified:
//            throw CreditsError.failedVerification
//        case .verified(let safe):
//            return safe
//        }
//    }
//}
//
//
//import SwiftUI
//
//struct CreditsView: View {
//    @StateObject private var store = CreditsStore()
//    
//    var body: some View {
//        VStack {
//            if let product = store.product {
//                Text("Produto: \(product.displayName)")
//                Text("Descrição: \(product.description)")
//                Text("Preço: \(product.displayPrice)")
//                
//                if store.isPurchased {
//                    Text("Você já comprou este item.")
//                        .foregroundColor(.green)
//                } else {
//                    Button("Comprar 10 Créditos") {
//                        Task {
//                            await store.purchase()
//                        }
//                    }
//                }
//            } else {
//                Text("Carregando informações do produto...")
//            }
//            
//            if let errorDescription = store.action?.error?.localizedDescription {
//                Text(errorDescription)
//                    .foregroundColor(.red)
//            }
//        }
//        .onAppear {
//            store.reset()
//        }
//    }
//}

import Foundation
import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    // identificadores dos produtos de créditos
    private let productIds = ["credits_10", "credits_20", "credits_50"]

    // array para produtos e IDs comprados
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()

    // Saldo de créditos
    @Published private(set) var creditBalance: Int = 0
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil


    init() {
        // observa as atualizações de transações de compra
        self.updates = observeTransactionUpdates()
    }

    deinit {
        self.updates?.cancel()
    }

    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        
        // Busca o produto de créditos
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }

    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            // Compra bem-sucedida
            await transaction.finish()
            await addCredits(for: product.id)
            print("purchase \(product.id) successful")
        case .success(.unverified(_, _)):
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }

    private func addCredits(for productID: String) async {
        // Defina os créditos com base no produto comprado
        let creditsToAdd = productID == "credits_10" ? 10 :
                           productID == "credits_20" ? 20 :
                           productID == "credits_50" ? 50 : 0
        
        if creditsToAdd > 0 {
            creditBalance += creditsToAdd
        }
    }


    // att os produtos comprados e créditos
    func updatePurchasedProducts() async {
        for await result in Transaction.updates {
            guard case .verified(let transaction) = result else { continue }
            
            if productIds.contains(transaction.productID) {
                // define os créditos a serem adicionados com base no productID
                let creditsToAdd = transaction.productID == "credits_10" ? 10 :
                                   transaction.productID == "credits_20" ? 20 :
                                   transaction.productID == "credits_50" ? 50 : 0
                
                // atualizar o saldo de créditos
                await MainActor.run {
                    creditBalance += creditsToAdd
                }

                // termina a transação para que não seja processada novamente
                await transaction.finish()
            }
        }
    }



    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}



import SwiftUI
import StoreKit

struct CreditsView: View {
    @EnvironmentObject var storeKitManager: StoreKitManager
    @Environment(\.navigate) var navigate
    
    @State private var isLoading = false
    @State private var purchaseError: String?
    @State var viewSize: CGSize = .zero

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Loja")
                            .font(.title2)
                        Text("Compre créditos para corrigir suas redações")
                            .fontWeight(.semibold)
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
                            }
                        }
                    }
                    
                    
                    
                    
                    Text("OU")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.colorBrandPrimary500)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                    VStack(alignment: .leading) {
                        Text("Trilha de anúncios")
                            .font(.title2)
                        Text("Assista 11 anúncios e ganhe 1 crédito")
                            .fontWeight(.semibold)
                    }
                    
                    // TRILHA DE ANÚNCIOS
                    SnakeButtonGridView()
                    
                    
                    
                    Spacer()
                }
                
                .ignoresSafeArea()
                .padding()
                // INICIO DO APP
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
                .getSize { size in
                    self.viewSize = size
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


// MARK: - SnakeButtonGridView
struct SnakeButtonGridView: View {
    let buttonCount: Int = 12
    @State private var buttonSize: CGSize = .zero
    @State private var completedButtons: [Int: Bool] = [1: true]
    @State private var currentButton: Int = 1 // PROPAGANDA ATUAL
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(getRows().indices, id: \.self) { rowIndex in
                let row = getRows()[rowIndex]
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { buttonNumber in
                        if buttonNumber == buttonCount {
                            getGiftButton()
                        } else {
                            getButton(for: buttonNumber)
                        }
                        
                        // HORIZONTAIS
                        if buttonNumber != row.last {
                            // Verifica a direção da animação baseada no índice da fileira
                            HorizontalCircles(
                                isCompleted:
                                    (rowIndex % 2 == 0)
                                    ? buttonNumber < currentButton  //  fileiras pares
                                    : buttonNumber <= currentButton, //  fileiras ímpares
                                animateFromRight: rowIndex % 2 != 0 //  fileiras ímpares, anima da direita para a esquerda
                            )
                        }

                    }
                }
                
                // VERTICAIS
                if row.last?.isMultiple(of: 3) != nil && row.first != buttonCount {
                    VerticalCircles(alignment: row.last!.isMultiple(of: 2) ? .leading : .trailing, buttonSize: buttonSize, isCompleted: (currentButton > row.last!) && (currentButton > row.first!))
                }
            }
        }
        .padding(10)
    }
    
    // MARK: - FUNCIONTS
    func getRows() -> [[Int]] {
        return [
            [1, 2, 3],
            [6, 5, 4],
            [7, 8, 9],
            [buttonCount, 11, 10]
        ]
    }
    
    // MARK: - VIEWS
    
    // MARK: BOTÕES PARA ASSISTIR ADD
    @ViewBuilder
    func getButton(for number: Int) -> some View {
        Button {
            print("assistir ad")
            currentButton = number + 1
        } label: {
            Text("\(number)")
                .fontWeight(.bold)
                .frame(width: 75, height: 71)
                .background(
                    number == currentButton
                    ? Image(.adButtonReady)
                    : number < currentButton
                    ? Image(.adButtonCompleted)
                    : Image(.adButtonBlocked)
                )
                .foregroundStyle(number > currentButton ? .black : number == currentButton ? .white : Color(.secondaryLabel))
        }
        .animation(.easeInOut, value: currentButton)
        .disabled(number > currentButton)  // Apenas o botão atual é clicável
        .getSize { size in
            self.buttonSize = size
        }
    }
    
    // MARK:  BOTÃO FINAL DE RECOMPENSA
    @ViewBuilder
    func getGiftButton() -> some View {
        Button {
            // TODO: - GANHAR UM CRÉDITO
        } label: {
            // Exibindo a imagem
            Image(currentButton == buttonCount ? .unlockedGift : .lockedGift)
                .frame(width: 75, height: 65)
                .rotationEffect(
                    Angle(degrees: currentButton == buttonCount ? 10 : 0)
                )
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: currentButton)
        }
        .disabled(currentButton != buttonCount)
    }




    // MARK:  Círculos Horizontais
    @ViewBuilder
    func HorizontalCircles(isCompleted: Bool, animateFromRight: Bool) -> some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(isCompleted ? Color(.colorBrandPrimary300) : Color(.colorFillsPrimary))
                    .scaleEffect(isCompleted ? 1.2 : 0.8)
                    .animation(
                        .bouncy(duration: 0.5)
                            .delay(animateFromRight ? Double(2 - index) * 0.4 : Double(index) * 0.4),
                        value: isCompleted
                    )
            }
        }
    }








    // MARK:  Círculos Verticais
    @ViewBuilder
    func VerticalCircles(alignment: Alignment, buttonSize: CGSize, isCompleted: Bool) -> some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundStyle(isCompleted ? Color.blue : Color(.colorFillsPrimary))
            .frame(maxWidth: .infinity, alignment: alignment)
            .padding(.horizontal, buttonSize.width / 2)
    }
}








import SwiftUI

struct BuyCreditsButton: View {
    var numberOfCredits: Int
    var price: Double
    var iconSize: CGFloat = 40
    
    // Formata o preço manualmente para "2,90"
    private var formattedPrice: (String, String) {
        let priceString = String(format: "%.2f", price)
        let components = priceString.split(separator: ".")
        let reais = String(components[0])    // Parte antes da vírgula
        let centavos = String(components[1]) // Parte depois da vírgula
        return (reais, centavos)
    }
    
    // Determina o ícone com base no número de créditos
    private var selectedIcon: Image {
        switch numberOfCredits {
        case 1: return Image("coin1")
        case 4: return Image("coin2")
        default: return Image("coin3")
        }
    }
    
    var body: some View {
        VStack {
            // QUANTIDADE + ICONE
            HStack {
                Text(String(numberOfCredits))
                selectedIcon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize)
                    .padding(.top, 15)
            }
            .font(.system(size: 44))
            .fontWeight(.bold)
            
            Spacer()
            
            // PREÇO
            HStack(alignment: .bottom, spacing: 0) {
                Text("R$ ")
                Text(formattedPrice.0) // Parte antes da vírgula (número inteiro)
                    .bold()
                    .padding(.bottom, 2)
                Text(",\(formattedPrice.1)")   // Parte depois da vírgula
            }
            .font(.largeTitle)
        }
        .padding(20)
        .padding(.vertical, 20)
        .background(Color.colorBrandPrimary500)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.colorBrandPrimary700, radius: 0, y: 8)
        .frame(height: 200)
    }
}





#Preview {
    BuyCreditsButton(numberOfCredits: 1, price: 2.90)
}



#Preview {
    CreditsView()
        .environmentObject(StoreKitManager())
}
