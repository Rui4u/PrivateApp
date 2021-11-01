//
//  LoadingView.swift
//  PrivateApp
//
//  Created by sharui on 2021/11/1.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("解析中")
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
