//
//  PrivateForAppPage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI

struct PrivateForAppPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    let dataSource : [PrivateDataForAppModel] = PrivateViewModel().allDataSourceForApp()
    
    @State private var searchTerm : String = ""

    var body: some View {
        NavigationView() {
            VStack {
                SearchBar(text: $searchTerm)
                List() {
                    ForEach(dataSource.filter({ item in
                        if searchTerm.count == 0 {
                            return true;
                        } else {
                            return item.boundID.contains(searchTerm)
                        }
                    }),id:\.self) { item in
                        NavigationLink(destination: PrivateForAppDetailPage(detailData: item)){
                            PrivateForAppPageListItem(item: item)
                        }
                    }
                }
                .navigationBarTitle("Navigation", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            Text("Select an item")
        }
    }
    func addItem() {
        
    }
}




struct PrivateForAppPageListItem: View {
    let item: PrivateDataForAppModel
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "circle.grid.cross")
                VStack {
                    Text(item.boundID).lineLimit(1)
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
