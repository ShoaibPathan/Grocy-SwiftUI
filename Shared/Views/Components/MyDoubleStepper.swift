//
//  MyDoublePicker.swift
//  Grocy-SwiftUI
//
//  Created by Georg Meissner on 19.11.20.
//

import SwiftUI

struct MyDoubleStepper: View {
    @Binding var amount: Double

    var description: String
    var descriptionInfo: String?
    var minAmount: Double
    var amountStep: Double
    var amountName: String? = nil
    
    var errorMessage: String?
    
    var systemImage: String?
    
    @State private var showInfo: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1){
            HStack{
                Text(description.localized)
                if descriptionInfo != nil {
                    #if os(macOS)
                    Image(systemName: "questionmark.circle.fill")
                        .help(LocalizedStringKey(descriptionInfo ?? ""))
                    #elseif os(iOS)
                    Button(action: {
                        showInfo.toggle()
                    }, label: {
                        Image(systemName: "questionmark.circle.fill")
                    })
                    .help(LocalizedStringKey(descriptionInfo ?? ""))
                    .popover(isPresented: $showInfo, content: {
                        Text(descriptionInfo!.localized)
                    })
                    #endif
                }
            }
            HStack{
                if systemImage != nil {
                    Image(systemName: systemImage!)
                }
                TextField("", value: $amount, formatter: NumberFormatter())
                    .frame(width: 50)
                Stepper((amountName ?? "").localized, onIncrement: {
                    amount += amountStep
                }, onDecrement: {
                    if amount > minAmount {
                        amount -= amountStep
                    }
                })
            }
            if amount < minAmount {
                if errorMessage != nil {
                    Text(errorMessage!.localized)
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(width: 200)
                }
            }
        }
    }
}

struct MyDoubleStepper_Previews: PreviewProvider {
    static var previews: some View {
        MyDoubleStepper(amount: Binding.constant(0), description: "Description", descriptionInfo: "Description info Text", minAmount: 1.0, amountStep: 0.1, amountName: "QuantityUnit", errorMessage: "Error in inputsadksaklwkfleksfklmelsfmlklkmlmgkelsmkgmlemkl", systemImage: "tag")
            .padding()
    }
}
