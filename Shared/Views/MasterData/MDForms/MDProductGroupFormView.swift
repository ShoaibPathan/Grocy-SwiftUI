//
//  MDProductGroupForm.swift
//  Grocy-SwiftUI
//
//  Created by Georg Meissner on 19.11.20.
//

import SwiftUI

struct MDProductGroupFormView: View {
    @StateObject var grocyVM: GrocyViewModel = .shared
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var mdProductGroupDescription: String = ""
    
    @State private var showDeleteAlert: Bool = false
    
    var isNewProductGroup: Bool
    var productGroup: MDProductGroup?
    
    @State var isNameCorrect: Bool = false
    private func checkNameCorrect() -> Bool {
        let foundProductGroup = grocyVM.mdProductGroups.first(where: {$0.name == name})
        return isNewProductGroup ? !(name.isEmpty || foundProductGroup != nil) : !(name.isEmpty || (foundProductGroup != nil && foundProductGroup!.id != productGroup!.id))
    }
    
    private func resetForm() {
        if isNewProductGroup {
            self.name = ""
            self.mdProductGroupDescription = ""
        } else {
            self.name = productGroup!.name
            self.mdProductGroupDescription = productGroup!.mdProductGroupDescription ?? ""
        }
        isNameCorrect = checkNameCorrect()
    }
    
    private func saveProductGroup() {
        if isNewProductGroup {
            grocyVM.postMDObject(object: .product_groups, content: MDProductGroupPOST(id: grocyVM.findNextID(.product_groups), name: name, mdProductGroupDescription: mdProductGroupDescription, rowCreatedTimestamp: Date().iso8601withFractionalSeconds, userfields: nil))
        } else {
            grocyVM.putMDObjectWithID(object: .product_groups, id: productGroup!.id, content: MDProductGroupPOST(id: Int(productGroup!.id)!, name: name, mdProductGroupDescription: mdProductGroupDescription, rowCreatedTimestamp: productGroup!.rowCreatedTimestamp, userfields: nil))
        }
        grocyVM.getMDProductGroups()
    }
    
    private func deleteProductGroup() {
        grocyVM.deleteMDObject(object: .product_groups, id: productGroup!.id)
        grocyVM.getMDProductGroups()
    }
    
    var body: some View {
        Form {
            Section(header: Text("str.md.productGroup.info")){
                MyTextField(textToEdit: $name, description: "str.md.productGroup.name", isCorrect: $isNameCorrect, leadingIcon: "tag", isEditing: true, errorMessage: "str.md.productGroup.name.required")
                    .onChange(of: name, perform: { value in
                        isNameCorrect = checkNameCorrect()
                    })
                MyTextField(textToEdit: $mdProductGroupDescription, description: "str.md.description", isCorrect: Binding.constant(true), leadingIcon: "text.justifyleft", isEditing: true)
            }
            #if os(macOS)
            HStack{
                Button("str.cancel") {
                    NSApp.sendAction(#selector(NSPopover.performClose(_:)), to: nil, from: nil)
                }
                .keyboardShortcut(.cancelAction)
                Spacer()
                Button("str.save") {
                    saveProductGroup()
                    NSApp.sendAction(#selector(NSPopover.performClose(_:)), to: nil, from: nil)
                }
                .keyboardShortcut(.defaultAction)
            }
            #endif
            if !isNewProductGroup {
                Button(action: {
                    showDeleteAlert.toggle()
                }, label: {
                    Label("str.md.delete \("str.md.productGroup".localized)", systemImage: "trash")
                        .foregroundColor(.red)
                })
                .keyboardShortcut(.delete)
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text("str.md.productGroup.delete.confirm"), message: Text(""), primaryButton: .destructive(Text("str.delete")) {
                        deleteProductGroup()
                        #if os(macOS)
                        NSApp.sendAction(#selector(NSPopover.performClose(_:)), to: nil, from: nil)
                        #else
                        presentationMode.wrappedValue.dismiss()
                        #endif
                    }, secondaryButton: .cancel())
                }
            }
        }
        .navigationTitle(isNewProductGroup ? "str.md.productGroup.new" : "str.md.productGroup.edit")
        .animation(.default)
        .onAppear(perform: {
            resetForm()
        })
        .toolbar(content: {
            #if os(iOS)
            ToolbarItem(placement: .cancellationAction) {
                if isNewProductGroup {
                    Button("str.cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("str.md.save \("str.md.quantityUnit".localized)") {
                    saveProductGroup()
                    presentationMode.wrappedValue.dismiss()
                }.disabled(!isNameCorrect)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                // Back not shown without it
                if !isNewProductGroup{
                    Text("")
                }
            }
            #endif
        })
    }
}

struct MDProductGroupFormView_Previews: PreviewProvider {
    static var previews: some View {
        #if os(macOS)
        Group {
            MDProductGroupFormView(isNewProductGroup: true)
            MDProductGroupFormView(isNewProductGroup: false, productGroup: MDProductGroup(id: "0", name: "Name", mdProductGroupDescription: "Description", rowCreatedTimestamp: "", userfields: nil))
        }
        #else
        Group {
            NavigationView {
                MDProductGroupFormView(isNewProductGroup: true)
            }
            NavigationView {
                MDProductGroupFormView(isNewProductGroup: false, productGroup: MDProductGroup(id: "0", name: "Name", mdProductGroupDescription: "Description", rowCreatedTimestamp: "", userfields: nil))
            }
        }
        #endif
    }
}
