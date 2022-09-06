//
//  UINavigationBar++Extensions.swift
//
//
//  Created by Kiarash Vosough on 7/21/22.
//

import UIKit

extension UINavigationBar {

    func insert(to view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}
