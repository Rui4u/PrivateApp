//
//  PrivateForAppDetailPage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI

struct PrivateForAppDetailPage: View {
    let detailData: PrivateDataForAppModel
    var warringTimes: Int = 0
    var body: some View {
        List{
            
            let result = UserDataSourceManager.findChartsData(dataSource: detailData.accessors, onlyLastDay: true)
            CharsView(dataSource: result,
                      waringTimes: warringTimes)
            
            Section(header: Text("记录")) {
                NavigationLink(destination: PrivateLocationDetailListPage(dataSource: detailData.accessors)){
                    HStack{
                        Image(systemName: "hand.raised.slash")
                            .foregroundColor(.red)
                        Text("访问记录")
                    }
                }
                
                NavigationLink(destination: Text("没写呢")) {
                    HStack {
                        Image(systemName: "network")
                            .foregroundColor(.blue)
                        Text("网络活动")
                    }
                }
            }
        }
        .navigationTitle(UserDataSourceManager.appName(boundId: detailData.boundID))
        .listStyle(GroupedListStyle())
        .onAppear {
            Request().loadData(boundId: detailData.boundID)
        }
    }
    
    
}

struct PrivateForAppDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            PrivateForAppPage().previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
    }
}
