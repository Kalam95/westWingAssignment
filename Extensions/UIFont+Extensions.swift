//
//  UIFont+Extensions.swift
//  CampaignBrowser
//
//  Created by mehboob Alam on 24/08/21.
//  Copyright © 2021 Westwing GmbH. All rights reserved.
//

import UIKit

extension UIFont {
    static var helviticaBold: UIFont {
        UIFont(name: "HelveticaNeue-Bold", size: 16) ?? .systemFont(ofSize: 16)
    }

    static var hoeflerTextRegular: UIFont {
        UIFont(name: "HoeflerText-Regular", size: 12) ?? .systemFont(ofSize: 12)
    }
}
