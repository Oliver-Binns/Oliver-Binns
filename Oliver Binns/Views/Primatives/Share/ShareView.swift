//
//  ShareView.swift
//  Oliver Binns
//
//  Created by Oliver Binns on 28/10/2020.
//
import SwiftUI
import UIKit

struct ShareView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }

    func updateUIViewController(_ viewController: UIActivityViewController,
                                context: Context) {

    }
}
