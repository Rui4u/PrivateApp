//
//  IconImage.swift
//  PrivateApp
//
//  Created by sharui on 2021/10/26.
//

import SwiftUI

struct IconImage: View {
    @State private var uiImage: UIImage? = nil
    let placeholderImage = UIImage(systemName: "square.dashed")!
    
    var imageUrl: String? = ""
    var body: some View {
        ZStack {
            if self.uiImage != nil {
                Image(uiImage: self.uiImage!)
                    .resizable()
                    .cornerRadius(8)
            } else {
                Image(systemName: "square.dashed")
                    .resizable()
                    .foregroundColor(Color.blue)
            }
        }
        
        .frame(width: 40, height: 40)
        .cornerRadius(4)
        .onAppear {
            fetchRemoteImage(url: imageUrl)
        }
    }
    
    func fetchRemoteImage(url:String?) //用来下载互联网上的图片
    {
        guard let url = URL(string: url ?? "") else {return } //初始化一个字符串常量，作为网络图片的地址
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self.uiImage = image
            }else {
                print("error: \(String(describing: error))")
            }
        }.resume()
    }
}

struct IconImage_Previews: PreviewProvider {
    static var previews: some View {
        IconImage(imageUrl: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.52112.com%2FJPG-180507%2F180507_96%2FsgGHrZklt0_small.jpg&refer=http%3A%2F%2Fpic.52112.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637828876&t=3cf67dbfc438c257754891683668b7b8")
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
