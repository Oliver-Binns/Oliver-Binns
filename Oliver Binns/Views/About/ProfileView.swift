//
//  ProfileView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 28/10/2020.
//
import SwiftUI

struct ProfileView: View {
    var body: some View {
        SafariButton(url: .businessCard) {
            Card(backgroundColor: .accentColor) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        VStack {
                            AsyncImage(url: .profileImage,
                                       placeholder: { ActivityIndicator(isAnimating: .constant(true), style: .large) },
                                       image: { Image(uiImage: $0).resizable() })
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                                Text("Oliver Binns")
                                    .font(.system(Font.TextStyle.largeTitle,
                                                  design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(
                                    """
                                    iOS Developer
                                    London, UK
                                    """)
                                    .font(.headline)
                        }
                    }
                    Text(
                        """
                        Hi, I’m a mobile & web developer originally from Halifax! I currently work in the mobile team at Deloitte Digital as a Senior iOS developer.

                        I have an integrated Master's Degree in Computer Science (with Year in Industry), which is accredited by the IET, from the University of York.

                        My interests in Computer Science lie mainly within the latest developments in Mobile and Web technologies, with a particular focus on native iOS applications.
                        """)
                }
            }.foregroundColor(.white)
        }
    }
}
