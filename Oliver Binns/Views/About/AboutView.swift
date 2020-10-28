//
//  AboutView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProfileView()
            /*Card {
                VStack(alignment: .leading) {
                    Text("iOS")
                        .font(.system(Font.TextStyle.largeTitle,
                                      design: .rounded))
                        .fontWeight(.bold)
                    Text("Oliver is an experienced iOS Developer.")
                    List {
                        HStack {

                        }
                    }
                }
            }
            Card(backgroundColor: Color(UIColor.systemGreen)) {
                Text("Android")
                    .font(.system(Font.TextStyle.largeTitle,
                                  design: .rounded))
                    .fontWeight(.bold)
            }.foregroundColor(.white)
            Card(backgroundColor: Color(UIColor.systemPurple)) {
                Text("Web")
                    .font(.system(Font.TextStyle.largeTitle,
                                  design: .rounded))
                    .fontWeight(.bold)
            }.foregroundColor(.white)
            Card(backgroundColor: Color(UIColor.systemTeal)) {
                Text("DevOps")
                    .font(.system(Font.TextStyle.largeTitle,
                                  design: .rounded))
                    .fontWeight(.bold)
            }*/
        }.padding(.bottom)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
