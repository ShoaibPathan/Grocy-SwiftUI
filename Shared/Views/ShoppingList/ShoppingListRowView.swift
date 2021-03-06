//
//  ShoppingListRowView.swift
//  Grocy-SwiftUI
//
//  Created by Georg Meissner on 26.11.20.
//

import SwiftUI

struct ShoppingListRowView: View {
    @StateObject var grocyVM: GrocyViewModel = .shared
    
    var shoppingListItem: ShoppingListItem
    
    var product: MDProduct {
        grocyVM.mdProducts.first(where: {$0.id == shoppingListItem.productID}) ?? MDProduct(id: "0", name: "Error Product", mdProductDescription: "error", productGroupID: "0", active: "0", locationID: "0", shoppingLocationID: nil, quIDPurchase: "0", quIDStock: "0", quFactorPurchaseToStock: "0", minStockAmount: "0", defaultBestBeforeDays: "0", defaultBestBeforeDaysAfterOpen: "0", defaultBestBeforeDaysAfterFreezing: "0", defaultBestBeforeDaysAfterThawing: "0", pictureFileName: nil, enableTareWeightHandling: "0", tareWeight: "0", notCheckStockFulfillmentForRecipes: "0", parentProductID: nil, calories: "0", cumulateMinStockAmountOfSubProducts: "0", dueType: "0", quickConsumeAmount: "0", rowCreatedTimestamp: "0", userfields: nil)
    }
    
    var quantityUnit: MDQuantityUnit {
        grocyVM.mdQuantityUnits.first(where: {$0.id == product.quIDStock}) ?? MDQuantityUnit(id: "0", name: "Error QU", mdQuantityUnitDescription: nil, rowCreatedTimestamp: "", namePlural: "Error QU", pluralForms: nil, userfields: nil)
    }
    
    var body: some View {
        HStack{
            ShoppingListRowActionsView(shoppingListItem: shoppingListItem)
            Divider()
            VStack(alignment: .leading){
                Text(product.name)
                    .font(.headline)
                    .strikethrough(shoppingListItem.done == "1")
                Text("\("str.shL.amount".localized): \(shoppingListItem.amount) \(shoppingListItem.amount == "1" ? quantityUnit.name : quantityUnit.namePlural)")
                    .strikethrough(shoppingListItem.done == "1")
            }
            .foregroundColor(shoppingListItem.done == "1" ? Color.gray : Color.primary)
        }
    }
}

struct ShoppingListRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ShoppingListRowActionsView(shoppingListItem: ShoppingListItem(id: "1", productID: "1", note: "note", amount: "1", rowCreatedTimestamp: "", shoppingListID: "", done: "0", quID: "", userfields: ""))
            ShoppingListRowView(shoppingListItem: ShoppingListItem(id: "1", productID: "1", note: "note", amount: "2", rowCreatedTimestamp: "ts", shoppingListID: "1", done: "0", quID: "1", userfields: nil))
        }
    }
}
