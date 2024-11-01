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
                                print("Attempting to purchase product: \(product.displayName)")
                                try await storeKitManager.buy(product)
                                print("Successfully purchased: \(product.displayName)")
                                
                                await storeKitManager.updatePurchasedProducts() // Força atualização
                            } catch {
                                print("Error occurred during purchase of \(product.displayName): \(error)")
                            }
                        }
                    } label: {
                        Text("\(product.displayPrice) - \(product.displayName)")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .task {
            print("Starting product update...")
            await storeKitManager.updatePurchasedProducts()
            print("Product update completed.")
        }
        .task {
            _ = Task<Void, Never> {
                do {
                    print("Loading products...")
                    try await storeKitManager.loadProducts()
                    print("Products loaded successfully.")
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
        print("StoreKitManager initialized.")
        self.updates = observeTransactionUpdates()
    }
    
    deinit {
        self.updates?.cancel()
        print("StoreKitManager deinitialized.")
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else {
            print("Products already loaded, skipping load.")
            return
        }
        
        do {
            self.products = try await Product.products(for: productIds)
            self.productsLoaded = true
            print("Products successfully loaded: \(self.products.map { $0.displayName })")
        } catch {
            print("Error loading products from StoreKit: \(error)")
            throw error
        }
    }
    
    func buy(_ product: Product) async throws {
        do {
            let result = try await product.purchase()
            
            switch result {
            case let .success(.verified(transaction)):
                print("Transaction verified for product: \(transaction.productID)")
                await transaction.finish()
                await self.updatePurchasedProducts()
                
            case let .success(.unverified(_, error)):
                print("Unverified transaction for \(product.displayName), possible issue: \(error)")
                
            case .pending:
                print("Transaction pending for product: \(product.displayName)")
                
            case .userCancelled:
                print("Transaction cancelled by user for product: \(product.displayName)")
                
            @unknown default:
                print("Unknown transaction result for product: \(product.displayName)")
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
                print("Unverified transaction encountered during update.")
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
                print("Added product ID to purchased products: \(transaction.productID)")
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
                print("Removed product ID from purchased products: \(transaction.productID)")
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
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
