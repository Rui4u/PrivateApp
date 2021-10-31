//
//  PrivateForAppMenuView.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/27.
//

import SwiftUI

struct PrivateForAppMenuView: View {
    @EnvironmentObject var manager: UserDataSourceManager
    @Binding var showMeumView: Bool
    @State var maxError = "10"
    var body: some View {
        
        List {
            Section(header: Text("类型")) {
                PrivateForAppMenuViewItem(selected: manager.sortType == .name, title: SortType.name.rawValue)
                    .onTapGesture {
                        manager.sortType = .name
                        withAnimation {
                            showMeumView.toggle()
                        }
                        
                    }
                PrivateForAppMenuViewItem(selected: manager.sortType == .locatioCount, title: SortType.locatioCount.rawValue).onTapGesture {
                    manager.sortType = .locatioCount
                    withAnimation {
                        showMeumView.toggle()
                    }
                }
            }
            
            Section(header: Text("排序方式")) {
                PrivateForAppMenuViewItem(selected: manager.sortByType == .up, title: SortByType.up.rawValue)
                    .onTapGesture {
                        manager.sortByType = .up
                        withAnimation {
                            showMeumView.toggle()
                        }
                        
                    }
                PrivateForAppMenuViewItem(selected: manager.sortByType == .down, title: SortByType.down.rawValue).onTapGesture {
                    manager.sortByType = .down
                    withAnimation {
                        showMeumView.toggle()
                    }
                }
            }
            
            Section(header: Text("警报阈值")) {
                HStack {
                    Text("1分钟内最多调用次数")
                    Spacer()
                    
                    
                    TextField("0", text: $maxError,onCommit: {
                        withAnimation {
                            showMeumView.toggle()
                        }
                    }).onReceive(maxError.publisher.reduce("", { t, c in
                        return t + String(c)
                    })) { text in
                        let times = Int(text) ?? 0
                        if manager.warringTimes != times {
                            manager.warringTimes = times
                        }
                    }
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
//        PrivateForAppMenuView(showMeumView:.constant(true), waringTimes: .constant("10"), sortModel:SortModel())
//    }
//}




