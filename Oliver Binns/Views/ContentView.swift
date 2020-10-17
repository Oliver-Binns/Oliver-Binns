//
//  ContentView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 12/09/2020.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                AboutView().readableGuidePadding()
            }.tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            NavigationView {
                PostPreviewsView()
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .tabItem {
                Image(systemName: "doc.text.fill")
                Text("Blog")
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
