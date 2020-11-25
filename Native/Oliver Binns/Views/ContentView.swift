//
//  ContentView.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 12/09/2020.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                PostPreviewsView()
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .tabItem {
                Image(systemName: "doc.text.fill")
                Text("Blog")
            }
            ScrollView {
                AboutView().readableGuidePadding()
            }
            .tabItem {
                Image(systemName: "info.circle.fill")
                Text("About")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
