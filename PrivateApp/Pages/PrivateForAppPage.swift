//
//  PrivateForAppPage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI

struct PrivateForAppPage: View {
//    @Environment(\.managedObjectContext) private var viewContext
    let dataSource : [PrivateDataForAppModel] = PrivateViewModel().allDataSourceForApp()
    
    @State private var showMeumView = false
    @ObservedObject var sortModel = SortModel()
    
    var body: some View {
        NavigationView() {
            ZStack (alignment: .leading){
                VStack {
                    SearchBar(text: $sortModel.filterByName)
                    
                    var result = dataSource.filter({ item in
                        if sortModel.filterByName.count == 0 {
                            return true;
                        } else {
                            return item.boundID.contains(sortModel.filterByName)
                        }
                    }).sorted { (item1, item2) in
                        if sortModel.sortByType == .name {
                            let a = item1
                                .boundID.localizedStandardCompare(item2.boundID) == ComparisonResult.orderedAscending
                            return a
                        } else if sortModel.sortByType == .locatioCount {
                            return item1.locationNums > item2.locationNums
                        }
                        
                            
                        return true
                    }
                    List() {
                        ForEach(result,id:\.self) { item in
                            NavigationLink(destination: PrivateForAppDetailPage(detailData: item)){
                                PrivateForAppPageListItem(item: item)
                            }
                        }
                    }
//                    .simultaneousGesture( DragGesture(minimumDistance: 1, coordinateSpace: .local) // can be changed to simultaneous gesture to work with buttons
//                                            .onChanged { value in
//
//                    }
//                                            .onEnded { value in
//                        hideKeyboard()
//                    }
//                    )
                    .refreshable {
                        hideKeyboard()
                    }
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
                }
                GeometryReader { reader in
                    let width = reader.size.width
                    let height = reader.size.height
                    MenuView(showMeumView: $showMeumView, sortModel: sortModel)
                        .frame(width: 300, height: height)
                        .position(x: showMeumView ? width - 150 : width + 300, y: height / 2)
                    
                        .opacity(showMeumView ? 1 : 0)
                }
                
            }
            
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



struct PrivateForAppPage_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            PrivateForAppPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct MenuItem: View {
    var sortModel: SortModel
    var selected: Bool
    var title: String = ""
    var body: some View {
        HStack {
            Image(systemName: selected ? "target" : "")
                .resizable()
                .frame(width: 10, height: 10)
            Text(title)
        }
    }
}

struct MenuView: View {
    @Binding var showMeumView: Bool
    var sortModel: SortModel
    var body: some View {
        List {
            Section(header: Text("类型")) {
                
                MenuItem(sortModel: sortModel, selected: sortModel.sortByType == .name, title: "名称")
                    .onTapGesture {
                        sortModel.sortByType = .name
                        withAnimation {
                            showMeumView.toggle()
                        }
                        
                    }
                MenuItem(sortModel: sortModel, selected: sortModel.sortByType == .locatioCount, title: "隐私访问数量").onTapGesture {
                    sortModel.sortByType = .locatioCount
                    withAnimation {
                        showMeumView.toggle()
                    }
                }
            }
//            Section(header: Text("排序")) {
//                MenuItem(selected: $selected, title: "升序")
//                MenuItem(selected: $selected, title: "降序")
//            }
        }
        .environment(\.defaultMinListHeaderHeight, 0.1) // HERE
        .cornerRadius(4)
        .listStyle(GroupedListStyle())
        .padding()
        .shadow(color: Color.gray.opacity(0.3), radius: 7, x: 0, y: 0)
    }
}


