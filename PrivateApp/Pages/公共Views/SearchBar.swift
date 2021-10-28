//
//  SearchBar.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/28.
//

import SwiftUI

struct SearchBar: View {
    @State var showCancelButton = false
    @Binding var title: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("search", text: $title, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(.primary)
                
                Button(action: {
                    title = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(title == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            if showCancelButton  {
                Button("Cancel") {
    //                            UIApplication.shared the other commands here
                    hideKeyboard()
                    title = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar()
//    }
//}
