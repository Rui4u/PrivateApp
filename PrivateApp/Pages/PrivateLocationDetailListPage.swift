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
    @State var image: UIImage = UIImage()
    var body: some View {
        ZStack {
            GeometryReader { reader in
                let width = reader.size.width
                let height = reader.size.height
                let urlString = UserDataSourceManager.appIconUrl(accessor: accessor)
                IconImage(imageUrl:urlString)
                    .frame(width: width, height: height)
                    .position(x: width / 2, y: height / 2)
                    .onAppear {
                        fetchRemoteImage()
                    }
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
    func fetchRemoteImage() //用来下载互联网上的图片
    {
        let appInfo = UserDataSourceManager.appInfo(boundId: accessor.accessor?.identifier ?? "")

        guard let url = URL(string: appInfo?.logoUrl ?? "") else { return } //初始化一个字符串常量，作为网络图片的地址
        URLSession.shared.dataTask(with: url){ (data, response, error) in //执行URLSession单例对象的数据任务方法，以下载指定的图片
            if let image = UIImage(data: data!){
                self.image = image //当图片下载成功之后，将下载后的数据转换为图像，并存储在remoteImage属性中
            }
            else{
                print(error ?? "") //如果图片下载失败之后，则在控制台输出错误信息
            }
        }.resume() //通过执行resume方法，开始下载指定路径的网络图片
    }
}

