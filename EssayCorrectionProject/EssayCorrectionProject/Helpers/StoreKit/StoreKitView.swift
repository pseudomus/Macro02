//
//  StoreKitView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 01/11/24.
//

import SwiftUI
import StoreKit

struct StoreKitView: View {
    @StateObject private var storeKitManager = StoreKitManager()
    
    var body: some View {
        VStack {
            if storeKitManager.hasPurchasedCredits {
                Text("Comprou parabens ai fudido")
            } else {
                Text("Créditos")
                ForEach(storeKitManager.products) { product in
                    Button {
                        _ = Task<Void, Never> {
                            do {
                                try await storeKitManager.buy(product)
                            } catch {
                                print("Error occurred during purchase of \(product.displayName): \(error)")
                            }
                        }
                    } label: {
                        Text("\(product.displayPrice) - \(product.displayName)")
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .task {
            await storeKitManager.updatePurchasedProducts()
        }
        .task {
            _ = Task<Void, Never> {
                do {
                    try await storeKitManager.loadProducts()
                } catch {
                    print("Error loading products: \(error)")
                }
            }
        }
    }
}

@MainActor
class StoreKitManager: ObservableObject {
    private let productIds = ["credits_10"]
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    var hasPurchasedCredits: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    init() {
        self.updates = observeTransactionUpdates()
    }
    
    deinit {
        self.updates?.cancel()
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    func buy(_ product: Product) async throws {
        do {
            let result = try await product.purchase()
            
            switch result {
            case let .success(.verified(transaction)):
                await transaction.finish()
                await self.updatePurchasedProducts()
                
            case let .success(.unverified(_, error)):
                break
            case .pending:
                break
            case .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            print("Error during purchase attempt for \(product.displayName): \(error)")
            throw error
        }
    }
    
    func updatePurchasedProducts() async {
        print("Updating purchased products...")
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                print("to aqui")
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
                print("to aqui agora")
            }
        }
    }
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            print("Observing transaction updates...")
            for await verificationResult in Transaction.updates {
                await self.updatePurchasedProducts()
                print("Processed transaction update.")
            }
        }
    }
}

#Preview {
    StoreKitView()
}
