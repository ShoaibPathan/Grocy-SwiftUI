//
//  StockFilterView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 29.10.20.
//

import SwiftUI

private struct StockFilterItemView: View {
    var num: Int
    @Binding var filteredStatus: ProductStatus
    var ownFilteredStatus: ProductStatus
    var normalColor: Color
    var lightColor: Color
    var darkColor: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .hidden()
                .frame(height: 10)
                .frame(width: 90)
                .background(normalColor)
            HStack {
                if filteredStatus == ownFilteredStatus {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
//                Text("\(String(num)) \(ownFilteredStatus.rawValue.localized)")
                Text(ownFilteredStatus.getDescription(amount: num))
                    .foregroundColor(darkColor)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            .background(lightColor)
        }
        .onTapGesture {
            if filteredStatus != ownFilteredStatus {
                filteredStatus = ownFilteredStatus
            } else {
                filteredStatus = ProductStatus.all
            }
        }
    }
}

struct StockFilterActionsView: View {
    @Binding var filteredStatus: ProductStatus
    
    var numExpiringSoon: Int
    var numOverdue: Int
    var numExpired: Int
    var numBelowStock: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                StockFilterItemView(num: numExpiringSoon, filteredStatus: $filteredStatus, ownFilteredStatus: ProductStatus.expiringSoon, normalColor: Color.grocyYellow, lightColor: Color.grocyYellowLight, darkColor: Color.grocyYellowDark)
                StockFilterItemView(num: numOverdue, filteredStatus: $filteredStatus, ownFilteredStatus: ProductStatus.overdue, normalColor: Color.grocyGray, lightColor: Color.grocyGrayLight, darkColor: Color.grocyGrayDark)
                StockFilterItemView(num: numExpired, filteredStatus: $filteredStatus, ownFilteredStatus: ProductStatus.expired, normalColor: Color.grocyRed, lightColor: Color.grocyRedLight, darkColor: Color.grocyRedDark)
                StockFilterItemView(num: numBelowStock, filteredStatus: $filteredStatus, ownFilteredStatus: ProductStatus.belowMinStock, normalColor: Color.grocyBlue, lightColor: Color.grocyBlueLight, darkColor: Color.grocyBlueDark)
            }
        }
    }
}

struct StockFilterActionsView_Previews: PreviewProvider {
    static var previews: some View {
        StockFilterActionsView(filteredStatus: .constant(.expired), numExpiringSoon: 1, numOverdue: 2, numExpired: 2, numBelowStock: 3)
    }
}
