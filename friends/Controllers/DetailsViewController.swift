//
//  DetailsViewController.swift
//  friends
//
//  Created by Faysal on 29/3/23.
//

import UIKit
import MessageUI

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = user.name.title + " " + user.name.first + " " + user.name.last
        cityLbl.text = user.location.city + ", " + user.location.state + ", " + user.location.country
        phoneLbl.text = user.phone
        addressLbl.text = "\(user.location.street.number), \(user.location.street.name), \(user.location.city), \(user.location.state), \(user.location.country)"
        profileImageView.layer.cornerRadius = 150
        emailBtn.setTitle(user.email, for: .normal)
        if let imageUrl = URL(string: user.picture.large) {
            ImageManager.shared.requestImage(url: imageUrl) { (image) in
                self.profileImageView.image = image
            }
        }

    }
  
    
    @IBAction func emailBtnAction(_ sender: UIButton) {
                
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([user.email])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
   
}

extension DetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
