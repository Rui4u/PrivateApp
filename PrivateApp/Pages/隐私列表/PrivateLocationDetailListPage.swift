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
        PrivateLocationDetailListPage(
            dataSource: TestDataMangaer.accessors()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}





