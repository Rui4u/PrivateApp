//
//  PrivateLocationDetailListPage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/20.
//

import SwiftUI

struct PrivateLocationDetailListPage: View {
    var dataSource: [Accessor]
    var body: some View {
        VStack {
            List() {
                ForEach(dataSource ,id:\.self) { accessor in
                    PrivateLocationDetailListItem(accessor: accessor)
                }
            }
            .navigationBarTitle("详情", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

struct PrivateLocationDetailListPage_Previews: PreviewProvider {
    static var previews: some View {
        PrivateLocationDetailListPage(dataSource: UserDataSourceManager.shared.accessors)
    }
}

struct PrivateLocationDetailListItem: View {
    var accessor: Accessor
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                ListHeaderIcon(accessor: accessor)
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    if accessor.haveTimeRange {
                        Text(stringConvertDate(string:accessor.timeStamp!) + "-" + stringConvertEndDate(string:accessor.endTimeStamp!)).font(.subheadline)
                        HStack() {
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.category))
                                .fontWeight(.heavy)
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.type))
                            Spacer()
                        }
                        
                    } else {
                        Text(stringConvertDate(string:accessor.timeStamp!)).font(.subheadline)
                        HStack {
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.category))
                                .fontWeight(.heavy)
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.kind))
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.type))
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd'T'HH:mm:ss.SSSxxx") -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let str = formatter.string(from: date!)
        return str
    }
    
    func stringConvertEndDate(string:String, dateFormat:String="yyyy-MM-dd'T'HH:mm:ss.SSSxxx") -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        formatter.dateFormat = "HH:mm:ss"
        let str = formatter.string(from: date!)
        return str
    }
}

struct ListHeaderIcon: View {
    var accessor: Accessor
    var body: some View {
        ZStack {
            GeometryReader { reader in
                let width = reader.size.width
                let height = reader.size.height
                let appInfo = UserDataSourceManager.shared.appInfo(boundId: accessor.accessor!.identifier!)
                Image(appInfo?.locationIconString ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .position(x: width / 2, y: height / 2)
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(
                        ZStack {
                            PrivateDataModelTools.subiconForHeadIcon(type: accessor.category!)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(width: 10, height: 10)
                        }
                    )
                    .position(x: width - 10, y: height - 10)
            }
        }
    }
}

