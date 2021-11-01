//
//  PrivateForAppHistoryList.swift
//  PrivateApp
//
//  Created by sharui on 2021/11/1.
//

import SwiftUI

struct PrivateForAppHistoryList: View {
    @Binding var showMeumView: Bool
    var body: some View {
        let searchList = LocationPrivateFileManager.findFile()
        List {
            Text("历史记录")
            ForEach (searchList, id: \.self) { item in
                HStack {
                    Text(item.name)
                        .font(.system(size: 14))
                    if PreferencesManager.shared.path == item.path {
                        Spacer()
                        Image(systemName: "tag.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.blue)
                    }
                }.onTapGesture {
                    PreferencesManager.shared.path = item.path
                    withAnimation {
                        showMeumView.toggle()
                    }
                }
            }
        }
        .environment(\.defaultMinListHeaderHeight, 0.1) // HERE
        .cornerRadius(4)
        .padding()
        .shadow(color: Color.gray.opacity(0.3), radius: 7, x: 0, y: 0)
    }
}

struct PrivateForAppHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        PrivateForAppHistoryList(showMeumView: .constant(true))
    }
}
