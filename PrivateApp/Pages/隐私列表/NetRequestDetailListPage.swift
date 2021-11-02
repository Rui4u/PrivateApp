//
//  NetRequestDetailListPage.swift
//  PrivateApp
//
//  Created by sharui on 2021/11/2.
//

import SwiftUI

struct NetRequestDetailListPage: View {
    var dataSource: [Network]
    var body: some View {
        VStack {
            List() {
                ForEach(dataSource ,id:\.self) { network in
                    NetworkDetailListItem(network: network)
                }
            }
            .navigationBarTitle("详情", displayMode: .inline)
        }
    }
}
//
//struct NetRequestDetailListPage_Previews: PreviewProvider {
//    static var previews: some View {
//        NetRequestDetailListPage()
//    }
//}
