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
    @State private var showHistoryView = false
    @State private var showHelp = false;
    var body: some View {
        if (manager.path.count == 0 && false) {
            Help(showHelp: $showHelp)
        } else {
            NavigationView() {
                ZStack (alignment: .leading){
                    PrivateForAppList().environmentObject(manager)
                        .disabled(showMeumView || showHistoryView)
                    GeometryReader { reader in
                        let width = reader.size.width
                        let height = reader.size.height
                        PrivateForAppMenuView(showMeumView: $showMeumView).environmentObject(manager)
                            .frame(width: 300, height: height)
                            .position(x: showMeumView ? width - 150 : width + 300, y: height / 2)
                            .opacity(showMeumView ? 1 : 0)
                        
                        
                        PrivateForAppHistoryList(showMeumView: $showHistoryView).environmentObject(manager)
                            .frame(width: 300, height: height)
                            .position(x: showHistoryView ?  150 : -150, y: height / 2)
                            .opacity(showHistoryView ? 1 : 0)
                        
                        
                    }
                }
                .navigationBarTitle("应用程序", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                showMeumView.toggle()
                            }
                        } label: {
                            Image(systemName: "gear").foregroundColor(.black)
                        }
                        .disabled(showHistoryView)
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                showHistoryView.toggle()
                            }
                        } label: {
                            Image(systemName: "folder").foregroundColor(.black)
                        }
                        .disabled(showMeumView)
                    }
                }
            }
        }
    }
}


struct PrivateForAppPage_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            PrivateForAppPage().environmentObject(UserDataSourceManager.shared).previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
    }
}




