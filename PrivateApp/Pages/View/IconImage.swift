//
//  IconImage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/26.
//

import SwiftUI

struct IconImage: View {
    @State private var image: UIImage = UIImage(systemName: "square.dashed") ?? UIImage()
    var imageUrl: String? = ""
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(4)
                .foregroundColor(.blue)
                .onAppear {
                    fetchRemoteImage(url: imageUrl)
                }
        }
    }
    
    func fetchRemoteImage(url:String?) //用来下载互联网上的图片
    {
        guard let url = URL(string: url ?? "") else {return } //初始化一个字符串常量，作为网络图片的地址
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

struct IconImage_Previews: PreviewProvider {
    static var previews: some View {
        IconImage(imageUrl: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.52112.com%2FJPG-180507%2F180507_96%2FsgGHrZklt0_small.jpg&refer=http%3A%2F%2Fpic.52112.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637828876&t=3cf67dbfc438c257754891683668b7b8")
    }
}
