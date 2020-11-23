//
//  TwitterView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 10/10/2020.
//

import SwiftUI

struct TwitterView: View {
    var body: some View {
        Link("Tweet @Oliver_Binns",
             destination: URL(string: "https://www.twitter.com/Oliver_Binns")!)
    }
}

struct TwitterView_Previews: PreviewProvider {
    static var previews: some View {
        TwitterView()
    }
}
