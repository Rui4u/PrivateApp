//
//  PrivateForAppPage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI

struct PrivateForAppPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    let dataSource : [PrivateDataForAppModel] = UserDataSourceManager.shared.allDataSourceForApp()

    @State private var showMeumView = false
    @ObservedObject var sortModel = UserPreferencesManager.shared.sortModel
    @State var warringTimes = UserPreferencesManager.shared.warringTimes
    
    var body: some View {
        
        NavigationView() {
            ZStack (alignment: .leading){
                PrivateForAppList(sortModel: sortModel,
                                  warringTimes: $warringTimes,
                                  dataSource: dataSource)
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
                    PrivateForAppMenuView(showMeumView: $showMeumView,waringTimes: $warringTimes, sortModel: sortModel)
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
            PrivateForAppPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
    }
}



