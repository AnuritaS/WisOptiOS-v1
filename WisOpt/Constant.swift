//
//  Constant.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 21/10/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit

class Constant {
    //bundle id monkWish.WisOpt
    //UIColor(rgb: 0x476ae8)
    func getProfession() -> String {
        return Session.getString(forKey: Session.PROFESSION)
    }


    func anime(_ myTableView: UITableView) {

        let cells = myTableView.visibleCells
        var delay: Double = 0
        for i in cells {
            i.transform = CGAffineTransform(translationX: 0, y: myTableView.frame.height)

        }
        for i in cells {

            UIView.animate(withDuration: 1.75, delay: delay * 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                i.transform = CGAffineTransform.identity;
                delay += 1
            }, completion: nil)
        }
        myTableView.refreshControl?.endRefreshing()


    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
