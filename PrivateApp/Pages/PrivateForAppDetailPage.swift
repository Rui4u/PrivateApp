//
//  PrivateForAppDetailPage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI

struct PrivateForAppDetailPage: View {
    let detailData: PrivateDataForAppModel
    var body: some View {
            List{
                Section(header: Text("记录")) {
                    NavigationLink(destination: PrivateLocationDetailListPage(dataSource: detailData.accessors)){
                        HStack{
                            Image(systemName: "hand.raised.slash").foregroundColor(.red)
                            Text("访问记录")
                        }
                    }
            
                    NavigationLink(destination: Text("没写呢")) {
                        HStack {
                            Image(systemName: "network").foregroundColor(.blue)
                            Text("网络活动")
                        }
                    }
                }
                
                let result = UserDataSourceManager.findCharsData(interval: 60, type: "location", dataSource: detailData.accessors)
                ZStack {
                    GeometryReader { reader in
                        CharsView(dataSource: result)
                            .frame(width: reader.size.width, height: reader.size.height)
                    }
                }.frame(height: 300)
                
            }.navigationTitle(detailData.boundID)
            .listStyle(GroupedListStyle())
    }
}

struct PrivateForAppDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            PrivateForAppDetailPage(detailData: PrivateViewModel().allDataSourceForApp().first!).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
    }
}
