//
//  PrivateForAppList.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/27.
//

import SwiftUI
import Combine
struct PrivateForAppList: View {
    @EnvironmentObject var manager: PreferencesManager
    @State var searchTitle =  ""
//    @Binding var disabledClick: Bool;
    @State var isLoading = false
    var body: some View {
        ZStack {
            VStack {
                List() {
                    ForEach(filterList(),id:\.self) { item in
                        let jumpPage = PrivateForAppDetailPage(detailData: item, warringTimes:manager.warringTimes)
                        NavigationLink(destination: jumpPage) {
                            PrivateForAppPageListItem(item: item)
                        }
//                        .disabled(disabledClick)
                    }
                }
                .searchable(text: $manager.filterByName, prompt: "搜索")
                .refreshable {
                    hideKeyboard()
                }
            }
            
            if isLoading {
                LoadingView()
            }
        }
        .onReceive(PreferencesManager.shared.$path, perform: { item in
            reloadList(path: item)
        })
//        .onAppear {
//            if self.manager.allBinddingPath == true {
//                return;
//            }
//            self.manager.allBinddingPath = true;
//            let sink = Subscribers.Sink<String, Never>(receiveCompletion: { item in
//            }, receiveValue: {item in
//                reloadList(path: item)
//            })
//            PreferencesManager.shared.$path.subscribe(sink)
//        }
    }
    
    func reloadList(path : String) {
        
        self.isLoading = true;
        PreferencesManager.shared.allDataSourceForApp(path:path ) { result in
            self.isLoading =  false;
            manager.appListDataSource = result
            for item in result {
                Request().loadData(bundleID: item.boundID)
            }
        }
    }
    
    /// 筛选list
    func filterList() ->[PrivateDataForAppModel] {
        let filterName = manager.filterByName.lowercased()
        
        return manager.appListDataSource.filter({ item in
            if manager.filterByName.count == 0 {
                return true;
            } else {
                let appName = item.appInfo?.appName?.lowercased()
                let bundleId = item.boundID.lowercased()
                
                let nameContains = appName?.contains(filterName) ?? false
                return bundleId.contains(filterName) || nameContains
            }
        }).sorted { (item1, item2) in
            
            if manager.sortType == .name {
                if manager.sortByType == .up {
                    let a = item1
                        .boundID.localizedStandardCompare(item2.boundID) == ComparisonResult.orderedAscending
                    return a
                } else {
                    let a = item1
                        .boundID.localizedStandardCompare(item2.boundID) == ComparisonResult.orderedDescending
                    return a
                }
            } else if manager.sortType == .locatioCount {
                if manager.sortByType == .up {
                    return item1.locationNums > item2.locationNums
                }else {
                    return item1.locationNums < item2.locationNums
                }
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
                let url = PreferencesManager.appIconUrl(boundId: item.boundID)
                IconImage(imageUrl: url)
                VStack {
                    Text(PreferencesManager.appInfo(bundleId: item.boundID)?.appName ?? item.boundID)
                        .lineLimit(1)
                }
            }
            Spacer()
            VStack {
                RightItem(imageString:"hand.raised.slash",
                          imageColor: .red,
                          title: "\(item.locationNums)");
                Spacer()
                RightItem(imageString:  "network",
                          imageColor: .blue,
                          title: "\(item.netWorkNums)");
            }
        }
    }
    
    struct RightItem: View {
        var imageString: String
        var imageColor: Color
        var title: String
        
        var body: some View {
            HStack {
                Text(title)
                    .frame(minWidth: 30, alignment: .trailing)
                    .font(.system(size: 16))
                Image(systemName:imageString)
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundColor(imageColor)
            }
        }
    }
}

//struct PrivateForAppList_Previews: PreviewProvider {
//    static var previews: some View {
//        PrivateForAppList()
//    }
//}

