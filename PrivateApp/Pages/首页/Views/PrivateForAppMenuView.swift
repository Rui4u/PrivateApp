//
//  PrivateForAppMenuView.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/27.
//

import SwiftUI

struct PrivateForAppMenuView: View {
    @Binding var showMeumView: Bool
    var sortModel: SortModel
    var body: some View {
        List {
            Section(header: Text("类型")) {
                
                PrivateForAppMenuViewItem(sortModel: sortModel, selected: sortModel.sortByType == .name, title: "名称")
                    .onTapGesture {
                        sortModel.sortByType = .name
                        withAnimation {
                            showMeumView.toggle()
                        }
                        
                    }
                PrivateForAppMenuViewItem(sortModel: sortModel, selected: sortModel.sortByType == .locatioCount, title: "隐私访问数量").onTapGesture {
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

struct PrivateForAppMenuViewItem: View {
    var sortModel: SortModel
    var selected: Bool
    var title: String = ""
    var body: some View {
        HStack {
            Image(systemName: selected ? "target" : "")
                .resizable()
                .frame(width: 10, height: 10)
            Text(title)
            Spacer()
        }.background(Color.white)
    }
}

//struct PrivateForAppMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrivateForAppMenuView()
//    }
//}




