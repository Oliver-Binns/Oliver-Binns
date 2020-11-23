//
//  SafariView.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 27/10/2020.
//
import UIKit
import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: Context) { }
}
