//
//  Help.swift
//  PrivateApp
//
//  Created by sharui on 2021/11/1.
//

import SwiftUI



struct Help: View {
    @Binding var showHelp: Bool
    var body: some View {
        VStack {
            Image(systemName: "questionmark.folder")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            Text("暂未发现任何导入的文件,请导入隐私文件")
                .padding()
            Button("如何导入") {
                showHelp.toggle()
            }
        }.sheet(isPresented: $showHelp) {
            
        } content: {
            HelpDetail()
        }
    }
}

struct HelpDetail: View {
    var body: some View {
        List {
            HelpSection(setup:1, title: "打开", actionName: "系统设置")
            HelpSection(setup:2, title: "点击", actionName: "隐私", imageName: "1")
            HelpSection(setup:3, title: "点击", actionName: "记录App活动", imageName: "2")
            HelpSection(setup:4, title: "打开", actionName: "记录App活动", imageName: "3")
            HelpSection(setup:5, title: "点击", actionName: "储存活动", imageName: "4")
            HelpSection(setup:6, title: "选择", actionName: "隐私APP", imageName: "5")
        }
    }
}

struct Help_Previews: PreviewProvider {
    static var previews: some View {
        Help(showHelp: .constant(true))
    }
}

struct HelpSection: View {
    var setup: Int
    var title: String
    var actionName: String
    var imageName: String = ""
    
    var body: some View {
        Section {
            if imageName.count > 0 {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    
            }
            HStack {
                Text(String(setup))
                    .frame(width: 20, height: 20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                Text(title)
                Text(actionName).fontWeight(.heavy)
            }
        }
    }
}
