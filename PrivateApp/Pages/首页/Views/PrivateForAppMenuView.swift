//
//  PrivateForAppMenuView.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/27.
//

import SwiftUI

struct PrivateForAppMenuView: View {
    @Binding var showMeumView: Bool
    @Binding var waringTimes: String
    var sortModel: SortModel
    var body: some View {
        List {
            Section(header: Text("类型")) {
                PrivateForAppMenuViewItem(sortModel: sortModel, selected: sortModel.sortType == .name, title: SortType.name.rawValue)
                    .onTapGesture {
                        sortModel.sortType = .name
                        withAnimation {
                            showMeumView.toggle()
                        }
                        
                    }
                PrivateForAppMenuViewItem(sortModel: sortModel, selected: sortModel.sortType == .locatioCount, title: SortType.locatioCount.rawValue).onTapGesture {
                    sortModel.sortType = .locatioCount
                    withAnimation {
                        showMeumView.toggle()
                    }
                }
            }
            
            Section(header: Text("排序方式")) {
                PrivateForAppMenuViewItem(sortModel: sortModel, selected: sortModel.sortByType == .up, title: SortByType.up.rawValue)
                    .onTapGesture {
                        sortModel.sortByType = .up
                        withAnimation {
                            showMeumView.toggle()
                        }
                        
                    }
                PrivateForAppMenuViewItem(sortModel: sortModel, selected: sortModel.sortByType == .down, title: SortByType.down.rawValue).onTapGesture {
                    sortModel.sortByType = .down
                    withAnimation {
                        showMeumView.toggle()
                    }
                }
            }
            
            Section(header: Text("警报阈值")) {
                HStack {
                    Text("1分钟内最多调用次数")
                    Spacer()
                    
                    TextField(waringTimes, text: $waringTimes ,onCommit: {
                        withAnimation {
                            showMeumView.toggle()
                        }
                    })
                        .frame(width: 40, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke(Color.gray)
                        )
                }
            }
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

struct PrivateForAppMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateForAppMenuView(showMeumView:.constant(true), waringTimes: .constant("10"), sortModel:SortModel())
    }
}




