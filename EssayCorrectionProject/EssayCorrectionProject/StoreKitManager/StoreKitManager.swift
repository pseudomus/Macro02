//
//  StoreKitManager.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 13/11/24.
//


import Foundation
import StoreKit
import SwiftUI

// MARK: CREDITS IDS
let creditsProductsIds = [
    "credits_1",
    "credits_10",
]

import Foundation
import StoreKit
import SwiftUI

typealias PurchaseResult = Product.PurchaseResult
typealias TransactionListener = Task<Void, Error>


enum StoreError: LocalizedError {
    case failedVerification
    case serverUnavailable
    case unfinishedTransaction(productId: String)
    case system(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "A verificação do usuário falhou."
        case .serverUnavailable:
            return "O nosso servidor teve problemas em receber a sua compra. Relaxe, registramos a sua compra."
        case .unfinishedTransaction(let productId):
            switch productId {
            case "credits_1":
                return "Você tem 1 crédito esperando para ser processado!"
            case "credits_4":
                return "Você tem 4 créditos esperando para serem processados!"
            case "credits_8":
                return "Você tem 8 créditos esperando para serem processados!"
            default:
                return "Você tem créditos esperando para serem processados!"
            }
        case .system(let err):
            return err.localizedDescription
        }
    }
}


enum PurchaseAction: Equatable {
    case successful
    case failed(StoreError)
    
    static func == (lhs: PurchaseAction, rhs: PurchaseAction) -> Bool {
        switch (lhs, rhs) {
        case (.successful, .successful):
            return true
        case (let .failed(lhsErr), let .failed(rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        default:
            return false
        }
    }
}

@MainActor
class StoreKitManager: ObservableObject {
    
    @Published var creditBalance: Int = 0

    //private let productIds = ["credits_1"]
    @Published private(set) var products: [Product] = []
    @Published private(set) var action: PurchaseAction? {
        didSet {
            switch action {
            case .failed:
                hasError = true
            default:
                hasError = false
            }
        }
    }
    @Published var hasError = false
    private var transactionListener: TransactionListener?
    private let transactionService = TransactionService()
    
    var error: StoreError? {
        switch action {
        case .failed(let error):
            return error
        default:
            return nil
        }
    }
    
    // INIT
    init() {
        transactionListener = configureTransactionListener()
        
        Task { await loadProducts() }
    }
    
    // DEINIT
    deinit {
        transactionListener?.cancel()
    }

    
    
    
    func purchase(_ product: Product, userId: Int) async {
        do {
            let result = try await product.purchase()
            try await handlePurchase(from: result, from: userId)
        } catch {
            action = .failed(.system(error))
            print(error)
        }
    }
    
    func resetAction() {
        action = nil
    }
    
    private func configureTransactionListener() -> TransactionListener {
        Task { [weak self] in
            do {
                for await result in Transaction.updates {
                    let transaction = try self?.checkVerified(result)
                    self?.action = .successful
                    await transaction?.finish()
                }
            } catch {
                self?.action = .failed(.system(error))
            }
        }
    }
    
    private func loadProducts() async {
        do {
            let products = try await Product.products(for: creditsProductsIds)
            self.products = products.sorted(by: { $0.price < $1.price })
        } catch {
            action = .failed(.system(error))
            print(error)
        }
    }
    
    func handlePurchase(from result: PurchaseResult, from userId: Int) async throws {
        switch result {
        case .success(let verification):
            do {
                // Verifica a transação
                let transaction = try checkVerified(verification)
                
                // Envia a transação ao servidor; `sendToServer` lida com o resultado e finaliza a transação se o envio for bem-sucedido
                await sendToServer(transaction: transaction, userId: userId)
            } catch {
                // Caso a verificação falhe
                action = .failed(.system(error))
                print("Falha na verificação da transação: \(error)")
            }
            
        case .pending:
            print("O usuário precisa completar uma ação antes de finalizar a compra.")
            
        case .userCancelled:
            print("O usuário cancelou a compra.")
            
        default:
            print("Erro desconhecido na compra.")
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let transaction):
            return transaction
        }
    }
    
    // ENVIAR AO SERVIDOR
    func sendToServer(transaction: StoreKit.Transaction, userId: Int) async {
        do {
            try await transactionService.sendTransactionToServer(transaction: transaction, userId: userId)
            await transaction.finish()
            await loadCreditBalance(userId: userId)
            action = .successful
        } catch {
            action = .failed(.serverUnavailable)

            print("Falha ao enviar a transação para o servidor: \(error)")
        }
    }

    
    func processUnfinishedTransactions() async {
        for await unfinishedTransaction in Transaction.unfinished {
            guard case .verified(let transaction) = unfinishedTransaction else { continue }

            do {
                let productID = transaction.productID

                action = .failed(.unfinishedTransaction(productId: productID))
                // tenta enviar ao servidor de novo
                // try await sendToServer(transaction: transaction)

            } catch {
                print("Falha ao processar transação pendente para o produto \(transaction.productID): \(error)")
            }
        }
    }

    // carregar o saldo de créditos do servidor
    func loadCreditBalance(userId: Int) async {
        do {
            let newBalance = try await transactionService.getCreditBalance(userId: userId)
            DispatchQueue.main.async {
                self.creditBalance = newBalance
            }
        } catch {
            print("Erro ao carregar o saldo de créditos: \(error)")
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
