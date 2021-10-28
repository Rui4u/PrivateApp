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
        let iconInfo = PrivateType.iconInfo(rawValue:accessor.category!)
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
                            Text(iconInfo.name!)
                                .fontWeight(.heavy)
                            Text(PrivateDataModelTools.conversionEnglishToChinese(accessor.type))
                            Spacer()
                        }
                        
                    } else {
                        Text(beginTime)
                        HStack {
                            Text(iconInfo.name!)
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
        let iconInfo = PrivateType.iconInfo(rawValue:accessor.category!)
        ZStack {
            GeometryReader { reader in
                let width = reader.size.width
                let height = reader.size.height
                let urlString = UserDataSourceManager.appIconUrl(accessor: accessor)
                IconImage(imageUrl:urlString)
                    .frame(width: width, height: height)
                    .position(x: width / 2, y: height / 2)
                Circle()
                    .fill(iconInfo.permissionsIconForegroundColor)
                    .frame(width: 16, height: 16)
                    .overlay(
                        ZStack {
                            Image(systemName: iconInfo.permissionsIconString)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 10, height: 10)
                        }
                    )
                    .position(x: width - 6, y: height - 6)
            }
        }
    }

}

struct ListHeaderIcon_Previews: PreviewProvider {
    static var previews: some View {
        PrivateLocationDetailListItem(accessor: TestDataMangaer.accessor())
    }
}
