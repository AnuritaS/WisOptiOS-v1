// WisOpt copyright Monkwish 2017

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import Fabric
import Crashlytics
import Onboard
import InAppNotify
import SwiftEventBus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])
        self.logUser()
        IQKeyboardManager.sharedManager().enable = true

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: { _, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        FirebaseApp.configure()
        Utils.subscribeToTopics()

        //self.tabBar()
        self.firstLogin()
        return true
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Token: \(fcmToken)")
        Utils.subscribeToTopics()
    }

    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }

    func tabBar() {
        let tabbar = UITabBarController().tabBar
        tabbar.barTintColor = UIColor.white
        tabbar.isTranslucent = false
        tabbar.layer.shadowColor = UIColor.black.cgColor
        tabbar.layer.shadowOpacity = 0.2
        tabbar.layer.shadowRadius = 10
        tabbar.shadowImage = UIImage()
        tabbar.backgroundImage = UIImage()

    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID 1: \(messageID)")
        }
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Reached here")

        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID 2: \(messageID)\n")
        }

        if application.applicationState == .active {
            print("Active State")

            //special case for notification type 6
            refreshAck(userInfo: userInfo)

            //other notification
            otherNotification(userInfo: userInfo)
        } else {
            print("Background State")

            //print("UserInfo: \(userInfo)\n")
            handleNotification(userInfo: userInfo)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func handleNotification(userInfo: [AnyHashable: Any]) {
        //let messageID = userInfo["gcm.notification.message"]
        //print("Message: \(String(describing: messageID))\n")

        let n_t = userInfo["gcm.notification.n_type"]

        if (n_t == nil) {
            return
        } else {
            let n_type = n_t as! String

            print("NTYPE: \(n_type)\n")

            if n_type == "1" {
                let groupData = userInfo["gcm.notification.group"]
                //let lastMessageData = userInfo["gcm.notification.lastMessage"]
                //let countData = userInfo["gcm.notification.count"]

                //print("Group: \(groupData!)\n")
                //print("LastMessage: \(lastMessageData!)\n")
                //print("Count: \(countData!)\n")


                let group = Group(JSONString: String(describing: groupData!))

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageViewController

                viewController.group = group
                viewController.isNotification = true

                let navController = UINavigationController.init(rootViewController: viewController)

                if let window = self.window, let rootViewController = window.rootViewController {
                    var currentController = rootViewController
                    while let presentedController = currentController.presentedViewController {
                        currentController = presentedController
                    }
                    currentController.present(navController, animated: true, completion: nil)
                }
            } else if n_type == "3" {
                let groupData = userInfo["gcm.notification.group"]
                print("Group: \(groupData!)\n")

                let group = Group(JSONString: String(describing: groupData!))
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "infoVC") as! InfoViewController

                viewController.group = group
                viewController.isNotification = true

                let navController = UINavigationController.init(rootViewController: viewController)

                if let window = self.window, let rootViewController = window.rootViewController {
                    var currentController = rootViewController
                    while let presentedController = currentController.presentedViewController {
                        currentController = presentedController
                    }
                    currentController.present(navController, animated: true, completion: nil)
                }
            } else if n_type == "4" {
                let header = userInfo["gcm.notification.header"]
                let message = userInfo["gcm.notification.message"]

                Utils.showAlert(title: String(describing: header!), message: String(describing: message!), presenter: (self.window?.rootViewController!)!)
            } else if n_type == "5" {
                let groupData = userInfo["gcm.notification.group"]
                //let lastReplyData = userInfo["gcm.notification.lastReply"]
                let announcementData = userInfo["gcm.notification.announcement"]

                //print("Group: \(groupData!)\n")
                //print("LastReply: \(lastReplyData!)\n")
                //print("Announcement: \(announcementData!)\n")

                let group = Group(JSONString: String(describing: groupData!))
                let announcement = Announcements(JSONString: String(describing: announcementData!))


                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //print("TYPE",announcement!.type!)
                if (announcement!.type! == "image") {
                    print("Image")
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "enlargeImage") as? EnlargeImageViewController {

                        viewController.group = group
                        viewController.message = announcement
                        viewController.isText = announcement?.type
                        viewController.isNotification = true
                        viewController.imageUrl = announcement!.message!

                        let navController = UINavigationController.init(rootViewController: viewController)

                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(navController, animated: true, completion: nil)
                        }
                    }
                } else {
                    print("Other")
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "replyVC") as? ReplyViewController {

                        viewController.group = group
                        viewController.message = announcement
                        viewController.isText = announcement?.type
                        viewController.isNotification = true

                        let navController = UINavigationController.init(rootViewController: viewController)

                        if let window = self.window, let rootViewController = window.rootViewController {
                            var currentController = rootViewController
                            while let presentedController = currentController.presentedViewController {
                                currentController = presentedController
                            }
                            currentController.present(navController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    func refreshAck(userInfo: [AnyHashable: Any]) {
        let n_t = userInfo["gcm.notification.n_type"]

        if (n_t == nil) {
            return
        } else {
            let n_type = n_t as! String

            print("NTYPE: \(n_type)\n")

            if n_type == "6" {
                SwiftEventBus.post("refresh")
                return
            }
        }
    }

    func otherNotification(userInfo: [AnyHashable: Any]) {
        //print(userInfo)

        guard
                let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
                let alert = aps["alert"] as? NSDictionary,
                let body = alert["body"] as? String,
                let title = alert["title"] as? String
                else {
            // handle any error here
            return
        }

        print("Title: \(title) \nBody:\(body)")

        SwiftEventBus.post("notification")

        let announce = Announcement(
                //Title, the first line
                title: title,
                //Subtitle, the second line
                subtitle: body,
                //Image local, show if no urlImage is set
                //image           : UIImage(named: "test"),
                //URL of remote image
                //urlImage        : "https://.....",
                //Seconds before disappear
                duration: 3,
                //Interaction type. none or text
                interactionType: InteractionType.none,
                //Pass data to annoucement
                userInfo: userInfo,
                //Action callback
                action: { (type, string, announcement) in

                    //You can detect the action by test "type" var
                    if type == CallbackType.tap {
                        print("User has been tapped")
                        self.handleNotification(userInfo: announcement.userInfo! as! [AnyHashable: Any])
                    } else if type == CallbackType.text {
                        print("Reply from notification: \(string!)")
                    } else {
                        print("Notification has been closed!")
                    }
                }
        )

        let controller = UIApplication.topViewController()
        InAppNotify.Show(announce, to: controller!)
    }

    func firstLogin() {

        if (!Session.getBool(forKey: Session.FIRST_TIME_LOGIN)) {
            self.onBoarding()
        } else if (Session.getBool(forKey: Session.SIGNED_IN)) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
            self.window?.rootViewController = controller
        }
    }

    func onBoarding() {

        let firstPage = OnboardingContentViewController(title: "Welcome to WisOpt", body: "Fast and seamless student-teacher communication app", image: UIImage(named: "logo"), buttonText: nil) {
        }
        let secondPage = OnboardingContentViewController(title: "Groups", body: "Join groups by using unique code or scanning bar code", image: UIImage(named: "groupIcon"), buttonText: nil) {
        }
        let thirdPage = OnboardingContentViewController(title: "Send Messages", body: "Read announcements and raise queries", image: UIImage(named: "messageicon"), buttonText: nil) {
        }
        let fourthPage = OnboardingContentViewController(title: "Documents", body: "Share documents and images", image: UIImage(named: "documenticon"), buttonText: "Get Started") { () -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginNC")
            self.window?.rootViewController = controller
        }

        let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "background"), contents: [firstPage, secondPage, thirdPage, fourthPage])
        self.window?.rootViewController = onboardingVC

        Session.set(value: true, forKey: Session.FIRST_TIME_LOGIN)

        onboardingVC?.allowSkipping = true
        onboardingVC?.skipHandler = {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginNC")
            self.window?.rootViewController = controller
        }

    }

    func logUser() {
        // You can call any combination of these three methods
        let u_id = Session.getInteger(forKey: Session.ID)
        let email = Session.getString(forKey: Session.EMAIL)
        let name = Session.getString(forKey: Session.NAME)
        
        Crashlytics.sharedInstance().setUserEmail("\(email)")
        Crashlytics.sharedInstance().setUserIdentifier("\(u_id)")
        Crashlytics.sharedInstance().setUserName("\(name)")
    }


    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}



