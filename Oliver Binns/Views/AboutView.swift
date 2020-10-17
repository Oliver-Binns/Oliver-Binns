//
//  AboutView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Circle()
                    .stroke(Color.accentColor)
                    .frame(width: 100, height: 100)
                Text("Oliver Binns")
                    .font(.largeTitle)
                Text(
                    """
                    Hi, I’m a mobile & web developer originally from Halifax!

                    I currently work in the mobile team at Deloitte Digital as a Senior iOS developer.

                    I have an integrated Master's Degree in Computer Science (with Year in Industry), which is accredited by the IET, from the University of York. My interests in Computer Science lie mainly within the latest developments in Mobile and Web technologies, with a particular on native iOS applications.
                    """)
            }.padding(16)
            Spacer()
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
