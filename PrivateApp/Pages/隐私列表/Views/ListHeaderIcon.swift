//
//  ListHeaderIcon.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/27.
//

import SwiftUI


struct PrivateLocationDetailListItem: View {
    var accessor: Accessor
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                ListHeaderIcon(accessor: accessor)
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    let beginTime = PrivateDataModelTools .stringConvertDate(string: accessor.timeStamp!, resultFormart: "yyyy/MM/dd HH:mm:ss")
                    
                    if accessor.haveTimeRange {
                        let endTime = PrivateDataModelTools .stringConvertDate(string: accessor.endTimeStamp!, resultFormart: "HH:mm:ss")
                        
                        Text(beginTime + "-" + endTime).font(.subheadline)
                        HStack() {
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.category))
                                .fontWeight(.heavy)
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.type))
                            Spacer()
                        }
                        
                    } else {
                        Text(beginTime)
                        HStack {
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.category))
                                .fontWeight(.heavy)
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.kind))
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.type))
                            Spacer()
                        }
                    }
                }.font(.subheadline)
            }
        }
    }
}

struct ListHeaderIcon: View {
    var accessor: Accessor
    var body: some View {
        ZStack {
            GeometryReader { reader in
                let width = reader.size.width
                let height = reader.size.height
                let urlString = UserDataSourceManager.appIconUrl(accessor: accessor)
                IconImage(imageUrl:urlString)
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

//struct ListHeaderIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        ListHeaderIcon()
//    }
//}
