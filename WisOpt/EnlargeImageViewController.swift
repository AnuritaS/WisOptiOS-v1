// WisOpt copyright Monkwish 2017

import UIKit
import Kingfisher

class EnlargeImageViewController: UIViewController {
    var message: Announcements?
    var group: Group?
    var isText: String?

    var reply: Reply? = nil
    var isReply = false

    var imageUrl = String()

    var isNotification = false

    @IBAction func goBack(_ sender: Any) {
        if (presentingViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
            self.present(controller, animated: true, completion: nil)
        }
    }

    @IBOutlet weak var enlargeImage: UIImageView!
    @IBOutlet weak var replies: UIButton!
    @IBOutlet weak var downloadImageB: UIButton!
    @IBOutlet weak var commentsButton: UIImageView!

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if isNotification {
            self.checkIsLogin()
            performSegue(withIdentifier: "commentVC", sender: self)
        }
        self.replyImage()
        downloadImageB.setTitleColor(UIColor.gray, for: .disabled)


        if (isReply) {
            replies.isHidden = true
            commentsButton?.isHidden = true
        } else {
            replies.isHidden = false
            commentsButton?.isHidden = false
        }
    }


    func replyImage() {
        self.downloadImageB.isEnabled = false
        let url = URL(string: imageUrl)

        enlargeImage.kf.setImage(with: url, completionHandler: {
            (image, error, cacheType, imageUrl) in
            // image: Image? `nil` means failed
            // error: NSError? non-`nil` means failed
            // cacheType: CacheType
            //                  .none - Just downloaded
            //                  .memory - Got from memory cache
            //                  .disk - Got from disk cache
            // imageUrl: URL of the image
            self.downloadImageB.isEnabled = true
        })

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

    @IBAction func downloadImage(_ sender: Any) {
        downloadImageB.isEnabled = false
        UIImageWriteToSavedPhotosAlbum(enlargeImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error, please check your permissions", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            self.downloadImageB.isEnabled = true
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Selected image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true, completion: {
                self.downloadImageB.isEnabled = true
            })
        }
    }
}

extension EnlargeImageViewController: UIPopoverPresentationControllerDelegate {

    @IBAction func openReplies(_ sender: Any) {
        performSegue(withIdentifier: "commentVC", sender: self)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentVC" {
            let controller = segue.destination as? ReplyViewController
            controller?.preferredContentSize = CGSize(width: 355, height: 500)
            controller?.popoverPresentationController?.delegate = self
            controller?.popoverPresentationController?.sourceView = replies.superview
            controller?.popoverPresentationController?.sourceRect = replies.frame
            controller?.message = message
            controller?.group = group
            controller?.isText = message?.type!
            controller?.view.backgroundColor = .white
        }
    }
}

