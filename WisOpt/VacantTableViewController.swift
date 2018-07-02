// WisOpt copyright Monkwish 2017

import UIKit

class VacantTableViewController: UITableViewController {

    var rooms: [Room]?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vacant Controller Loaded")

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as? RoomTableViewCell else {
            fatalError("The dequeued cell is not an instance of RoomTableViewCell.")
        }

        let room = rooms![indexPath.row]

        cell.titleL.text = "\(room.room!) - \(room.block!)"
        cell.subtitleL.text = "\(room.classFrom!) - \(room.classTo!)"

        //print("\(group.count)")

        return cell
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

}
