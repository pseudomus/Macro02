//
//  StoreKitManager.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//


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

//
//  CreditsError.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//


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
