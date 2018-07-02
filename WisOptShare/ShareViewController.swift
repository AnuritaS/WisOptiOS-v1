//
//  ShareViewController.swift
//  WisOptSHare
//
//  Created by WisOpt on 15/12/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here

        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem {
            for ele in item.attachments! {
                let itemProvider = ele as! NSItemProvider

                if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
                    NSLog("itemprovider: %@", itemProvider)
                    itemProvider.loadItem(forTypeIdentifier: "public.jpeg", options: nil, completionHandler: { (item, error) in

                        var imgData: Data!
                        if let url = item as? URL {
                            imgData = try! Data(contentsOf: url)
                        }

                        if let img = item as? UIImage {
                            imgData = UIImagePNGRepresentation(img)
                        }

                        let dict: [String: Any] = ["imgData": imgData, "name": self.contentText]

                        let userDefault = UserDefaults.standard
                        userDefault.addSuite(named: "group.wisoptShare")
                        userDefault.set(dict, forKey: "img")
                        userDefault.synchronize()
                    })
                }
            }
        }
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}

extension ShareViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? UITableViewCell
        return cell!
    }

}
