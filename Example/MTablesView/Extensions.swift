//
//  extensions.swift
//  Pods
//
//  Created by Ziyin Wang on 2017-02-18.
//
//

import UIKit

extension UIView {
    
    @available(iOS 9.0, *)
    func anchor(_ top:NSLayoutYAxisAnchor? = nil, left:NSLayoutXAxisAnchor? = nil, bottom:NSLayoutYAxisAnchor? = nil, right:NSLayoutXAxisAnchor? = nil, centerX:NSLayoutXAxisAnchor? = nil, centerY:NSLayoutYAxisAnchor? = nil, topConstant:CGFloat = 0, leftConstant:CGFloat = 0, bottomConstant:CGFloat = 0, rightConstant:CGFloat = 0, widthConstant:CGFloat = 0, heightConstant:CGFloat = 0) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top,constant: topConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom,constant: bottomConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left,constant: leftConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right,constant: -rightConstant))
        }
        
        if let centerX = centerX
        {
            anchors.append(centerXAnchor.constraint(equalTo: centerX))
        }
        
        if let centerY = centerY
        {
            anchors.append(centerYAnchor.constraint(equalTo: centerY))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}
