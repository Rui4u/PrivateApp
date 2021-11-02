//
//  PrivateForAppHistoryList.swift
//  PrivateApp
//
//  Created by sharui on 2021/11/1.
//

import SwiftUI

struct PrivateForAppHistoryList: View {
    @Binding var showMeumView: Bool
    @EnvironmentObject var manager: PreferencesManager // environment object

    var body: some View {
        List {
            Text("历史记录")
            ForEach (manager.fileHistory, id: \.self) { item in
                HStack {
                    let samePath = FileManager.default.contentsEqual(atPath: manager.path, andPath: item.path)
                    Image(systemName: samePath ? "tag.fill" :"")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.blue)
                    Spacer()
                    Text(item.name)
                        .font(.system(size: 12))
                        .lineLimit(2)
                }.onTapGesture {
                    PreferencesManager.shared.path = item.path
                    withAnimation {
                        showMeumView.toggle()
                    }
                }
            }
            .onDelete(perform: delete)
            .deleteDisabled(manager.fileHistory.count == 1)
        }
        .environment(\.defaultMinListHeaderHeight, 0.1) // HERE
        .cornerRadius(4)
        .padding()
        .shadow(color: Color.gray.opacity(0.3), radius: 7, x: 0, y: 0)
    }
    
    func delete(at offsets: IndexSet) {
        if let first = offsets.first { //获得索引集合里的第一个元素，然后从数组里删除对应索引的元素
            let path = LocationPrivateFileManager.findFile()[first].path
            LocationPrivateFileManager.deleteLocationFile(path: path)
            
            if path == PreferencesManager.shared.path { //删除当前选中时
                if first < manager.fileHistory.count {
                    PreferencesManager.shared.path = manager.fileHistory[first].path
                } else {
                    let historyCount = manager.fileHistory.count
                    if  historyCount > 0 {
                        PreferencesManager.shared.path = manager.fileHistory[historyCount - 1].path
                    }
                }
            }
        }
    }
}

struct PrivateForAppHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        PrivateForAppHistoryList(showMeumView: .constant(true))
    }
}
