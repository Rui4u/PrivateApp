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
            
            let result = PreferencesManager.findChartsData(dataSource: detailData.accessors, onlyLastDay: true)
            CharsView(dataSource: result,
                      waringTimes: warringTimes)
            
            Section(header: Text("记录")) {
                NavigationLink(destination: PrivateLocationDetailListPage(dataSource: detailData.accessors)){
                    DetailItem(imageName: "hand.raised.slash",
                               foregroundColor: .red,
                               leftText: "访问记录",
                               rightText: "\(detailData.locationNums)")
                }
                
                NavigationLink(destination: NetRequestDetailListPage(dataSource: detailData.networks)) {
                    DetailItem(imageName: "network",
                               foregroundColor: .blue,
                               leftText: "网络活动",
                               rightText: "\(detailData.netWorkNums)")
                }
            }
        }
        .navigationTitle(PreferencesManager.appName(boundId: detailData.boundID))
        .listStyle(GroupedListStyle())
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

struct DetailItem: View {
    var imageName: String
    var foregroundColor: Color
    var leftText: String
    var rightText: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(foregroundColor)
            Text(leftText)
            Spacer()
            Text(rightText)
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
    }
}
