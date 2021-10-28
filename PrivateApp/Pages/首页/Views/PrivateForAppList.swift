//
//  PrivateForAppList.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/27.
//

import SwiftUI


struct PrivateForAppList: View {
    @ObservedObject var sortModel : SortModel
    @Binding var warringTimes: String
    let dataSource : [PrivateDataForAppModel]
    var body: some View {
        VStack {
            SearchBar(title: $sortModel.filterByName)
            List() {
                ForEach(filterList(),id:\.self) { item in
                    NavigationLink(destination: PrivateForAppDetailPage(detailData: item, warringTimes:Int(warringTimes) ?? 0)){
                        PrivateForAppPageListItem(item: item)
                    }
                }
            }
            .refreshable {
                hideKeyboard()
            }
        }
    }
    
    /// 筛选list
    func filterList() ->[PrivateDataForAppModel] {
        dataSource.filter({ item in
            if sortModel.filterByName.count == 0 {
                return true;
            } else {
                return item.boundID.contains(sortModel.filterByName)
            }
        }).sorted { (item1, item2) in
            if sortModel.sortType == .name {
                let a = item1
                    .boundID.localizedStandardCompare(item2.boundID) == ComparisonResult.orderedAscending
                return a
            } else if sortModel.sortType == .locatioCount {
                return item1.locationNums > item2.locationNums
            }
            return true
        }
    }
}

struct PrivateForAppPageListItem: View {
    let item: PrivateDataForAppModel
    @State var image : UIImage = UIImage()
    var body: some View {
        HStack {
            HStack {
                let url = UserDataSourceManager.appIconUrl(boundId: item.boundID)
                IconImage(imageUrl: url)
                VStack {
                    Text(UserDataSourceManager.appInfo(boundId: item.boundID)?.name ?? item.boundID)
                        .lineLimit(1)
                }
            }
            Spacer()
            VStack {
                HStack {
                    Text("\(item.locationNums)").frame(minWidth: 30, alignment: .trailing)
                    Image(systemName: "hand.raised.slash").foregroundColor(.red)
                }
                HStack {
                    Text("\(item.netWorkNums)").frame(minWidth: 30, alignment: .trailing)
                    Image(systemName: "network").foregroundColor(.blue)
                }
            }
        }
    }
}

//struct PrivateForAppList_Previews: PreviewProvider {
//    static var previews: some View {
//        PrivateForAppList()
//    }
//}
