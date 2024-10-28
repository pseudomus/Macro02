//
//  BuyCreditsView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 25/10/24.
//

import SwiftUI
import StoreKit

struct BuyCreditsView: View {
    let models = Model.all
    var body: some View {
        List {
            ForEach(models) { model in
                Button(action: model.handler) {
                    Text(model.title)
                }
            }
        }
        
    }
}

#Preview {
    BuyCreditsView()
}


enum ProductEnum: String, CaseIterable {
    case credits5 = "com.seuapp.creditos5"
    case credits10 = "com.seuapp.creditos10"
    case credits15 = "com.seuapp.creditos15"
    case credits20 = "com.seuapp.creditos20"
}


final class IAPManager {
    static let shared = IAPManager()
    
    var products = [Product]()
    

    
    public func fetchProducts() async {
        let productsIDs: Set<String> = ["com.leonardomota.EssayCorrectionProject.credits5",
                                        "com.leonardomota.EssayCorrectionProject.credits10",
                                        "com.leonardomota.EssayCorrectionProject.credits15"]
        do {
            let fetchedProducts = try await Product.products(for: productsIDs)
            DispatchQueue.main.async {
                self.products = fetchedProducts
                print("Retornados: \(fetchedProducts.count)")
            }
        } catch {
            print("Erro ao buscar produtos: \(error)")
        }
    }
    
    
    public func purchase(product: ProductEnum) async {
        guard AppStore.canMakePayments else {
            print("Compras não estão permitidas.")
            return
        }
        
        guard let storeKitProduct = products.first(where: { $0.id == product.rawValue }) else {
            print("Produto não encontrado.")
            return
        }
        
        do {
            // Inicia a compra do produto usando a nova API `purchase()`
            let result = try await storeKitProduct.purchase()
            
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    print("Compra bem-sucedida para o produto: \(transaction.productID)")
                    await transaction.finish()
                case .unverified(_, let error):
                    print("Erro de verificação da transação: \(error.localizedDescription)")
                }
            case .userCancelled:
                print("Compra cancelada pelo usuário.")
            case .pending:
                print("Compra pendente.")
            @unknown default:
                break
            }
        } catch {
            print("Erro ao processar a compra: \(error.localizedDescription)")
        }
            
    }

    
}




struct Model: Identifiable {
    let id = UUID()
    let title: String
    let handler: (() -> Void)
    
    static var all: [Model] {
        [
            .init(title: "5 créditos", handler:{
                Task { await IAPManager.shared.purchase(product: .credits5) }
            }),
            .init(title: "10 créditos", handler:{
                Task { await IAPManager.shared.purchase(product: .credits10) }
            }),
            .init(title: "15 créditos", handler:{
                Task { await IAPManager.shared.purchase(product: .credits15) }
            }),
            .init(title: "20 créditos", handler:{
                Task { await IAPManager.shared.purchase(product: .credits20) }
            })
            
        ]
    }
}
