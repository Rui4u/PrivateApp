//
//  PrivateForAppPage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI

struct PrivateForAppPage: View {
//    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var manager: UserDataSourceManager // environment object
    @State private var showMeumView = false
        
    var body: some View {
        NavigationView() {

            ZStack (alignment: .leading){
                PrivateForAppList().environmentObject(manager)
                    .disabled(showMeumView)
                    .navigationBarTitle("Navigation", displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                withAnimation {
                                    showMeumView.toggle()
                                }
                            } label: {
                                Image(systemName: "gear").foregroundColor(.black)
                            }
                        }
                    }
                GeometryReader { reader in
                    let width = reader.size.width
                    let height = reader.size.height
                    PrivateForAppMenuView(showMeumView: $showMeumView).environmentObject(manager)
                        .frame(width: 300, height: height)
                        .position(x: showMeumView ? width - 150 : width + 300, y: height / 2)

                        .opacity(showMeumView ? 1 : 0)
                }
            }
        }
    }
}


struct PrivateForAppPage_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            PrivateForAppPage().previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
    }
}



