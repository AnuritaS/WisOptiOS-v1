// WisOpt copyright Monkwish 2017

import UIKit
import Alamofire
import FirebaseMessaging
import SwiftEventBus
import NVActivityIndicatorView

class GroupTableViewController: UITableViewController {

    //MARK: Properties
    var groups = [Group]()
    var isAdmin: Bool? = nil
    var selectedGroup: Group? = nil
    lazy var refreshContrl = UIRefreshControl()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()


    override func viewDidLoad() {
        super.viewDidLoad()


        SwiftEventBus.onMainThread(target as AnyObject, name: "notification") { result in
            // UI thread
            self.getGroups()
        }

        //hide white space
        self.extendedLayoutIncludesOpaqueBars = false
        self.edgesForExtendedLayout = UIRectEdge.all
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(GroupTableViewController.navigateToNextViewController))

        self.checkIsLogin()
        self.removeTabBarItem()

        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")

        let u_id = Session.getInteger(forKey: Session.ID)

        //let tc = preferences.string(forKey: "TOKEN_CODE")

        print("User Id: \(u_id)")


        if (token != nil && u_id != 0) {
            addToken(userId: u_id, token: token!)
        }

        self.tabBarController?.view.backgroundColor = .white
        self.refreshContrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshContrl.addTarget(self, action: #selector(getGroups), for: .valueChanged)
        self.tableView.refreshControl = refreshContrl

        self.tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupCell")
    }

    func addToken(userId: Int, token: String) {
        let url = URL(string: Utils.BASE_URL + "API")!
        let param: [String: String] = ["userId": "\(userId)", "token": "\(token)", "type": "iOS"]

        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("Add Token Successfull!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let serverResult = ServerResult(JSONString: utf8Text)

                            print(serverResult!.status!)

                        }
                    case .failure:
                        print("Error Ocurred! while adding token")
                    }
                }
    }

    @objc
    func navigateToNextViewController() {
        performSegue(withIdentifier: "ManageVC", sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.checkIsLogin()
        self.getGroups()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numOfSections: Int = 0
        if groups.count > 0 {
            numOfSections = 1
            tableView.backgroundView = nil
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "Your groups are loading or join some groups!"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return groups.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked Row at position \(indexPath[1])")
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let controller = storyboard.instantiateViewController(withIdentifier: "MessageVC")
        //self.present(controller, animated: true, completion: nil)

        selectedGroup = groups[indexPath[1]]

        performSegue(withIdentifier: "MessageViewController", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell else {
            fatalError("The dequeued cell is not an instance of GroupTableViewCell.")
        }

        let group = groups[indexPath.row]

        //print(group.lastTime.description)

        cell.titleL.text = "\(group.subjectName!)"

        let index = group.subjectName!.index((group.subjectName!.startIndex), offsetBy: 1)
        cell.group_label.text = "\(String(group.subjectName![..<index]))".uppercased()

        let u_id = Session.getInteger(forKey: Session.ID)
        if (group.groupAdmin! == u_id) {

            cell.admin_view.isHidden = false
        } else {

            cell.admin_view.isHidden = true
        }
        cell.messageL.text = "\(group.adminName!) - \(group.groupCode!)"
        //print("\(group.count)")

        if (group.replyCount == 0) {
            cell.indicatorL.isHidden = true
        } else {
            cell.indicatorL.isHidden = false
            cell.indicatorL.text = "R"
            //print("\(group.replyCount)")
        }

        if (group.count == 0) {
            cell.countL.isHidden = true
        } else {
            cell.countL.isHidden = false
            cell.countL.text = "\(group.count)"
        }

        // Configure the cell...

        return cell
    }

    //MARK: Other
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MessageViewController") {
            //get a reference to the destination view controller
            let destinationVC = segue.destination as! MessageViewController

            //set properties on the destination view controller
            destinationVC.group = selectedGroup
            //etc...
        }
    }

    @objc func getGroups() {
        let u_id = Session.getInteger(forKey: Session.ID)
        //print("\(u_id)")
        let tc = Session.getString(forKey: Session.TOKEN_CODE)
        
        let url = URL(string: Utils.BASE_URL + "API")!
        let param: [String: String] = ["token": tc, "userId": "\(u_id)"]
        //NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        Alamofire.request(url, method: .post, parameters: param)
                .responseJSON { response in
                    //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    switch response.result {
                    case .success:
                        print("Get Groups Successful!")

                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let getGroupList = GetGroupList(JSONString: utf8Text)
                            guard let grps = getGroupList?.groups else {
                                print("Group count error")
                                return
                            }
                            let counts = getGroupList?.counts
                            let replyCount = getGroupList!.replyCount!

                            //print(grps.count, counts!.count, replyCount.count)
                            //print(utf8Text)

                            self.groups.removeAll()

                            for i in 0..<grps.count {
                                let lastTime = counts![i].last_time!
                                let date = self.dateFormatter.date(from: lastTime)!

                                //print("Last Time::: ", lastTime, date.description)


                                let g = grps[i]

                                g.setCount(c: (counts?[i].count!)!)
                                if (replyCount.count != 0) {
                                    for i in replyCount {
                                        if (i.a_group_id! == g.groupId!) {
                                            g.setReplyCount(r: i.reply_s!)
                                        }
                                    }
                                }
                                g.setLastTime(t: date)

                                self.groups.append(g)
                            }

                            self.groups = self.groups.sorted(by: { $0.lastTime > $1.lastTime })

                            self.reloadTableView()
                        }
                    case .failure:
                        print("Error Ocurred!")

                        let alert = UIAlertController(title: "Error Ocurred!", message: "We are sorry for inconvenience.\nPlease Try Again.", preferredStyle: UIAlertControllerStyle.alert)

                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: {
                            action in
                            if (action.style == .default) {
                                self.getGroups()
                            }
                        }))

                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: {
                            action in
                            if (action.style == .cancel) {
                                print("Cancel")
                            }
                        }))

                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            print("Refreshing data")
            self.tableView.reloadData()
            if (self.tableView.refreshControl?.isRefreshing)! {
                Constant().anime(self.tableView)
            }
        }

    }

    func saveDataToDB(g: Group) {
    }

    func checkIsLogin() {
        let IS_LOGIN = Session.getBool(forKey: Session.IS_LOGIN)
        print("IS_LOGIN: \(IS_LOGIN)")

        if (!IS_LOGIN) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginNC")
            self.present(controller, animated: true, completion: nil)
        }

    }

    func setSelectedGroup() {

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func getBadgeValue() {

    }
}

extension GroupTableViewController {

    func removeTabBarItem() {
        let prof = Constant().getProfession()
        if prof == "Student" {
            print("No roomVC for student")

            if let tabBarController = self.tabBarController {
                let indexToRemove = 2
                if indexToRemove < (tabBarController.viewControllers?.count)! {
                    var viewControllers = tabBarController.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    tabBarController.viewControllers = viewControllers
                }
            }
        }
    }
}
