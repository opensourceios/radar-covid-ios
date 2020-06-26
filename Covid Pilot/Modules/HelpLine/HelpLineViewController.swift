//
//  HelpLineViewController.swift
//  Covid Pilot
//
//  Created by alopezh on 09/06/2020.
//  Copyright © 2020 Indra. All rights reserved.
//

import UIKit
import MessageUI

class HelpLineViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var router: AppRouter?
    var preferencesRepository: PreferencesRepository?
    
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var timeTableLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var phoneView: BackgroundView!
    
    @IBAction func onPollSelected(_ sender: Any) {
        if preferencesRepository?.isPollCompleted() ?? false {
            router?.route(to: Routes.PollFinished, from: self)
        } else {
            router?.route(to: Routes.Poll, from: self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTexts()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneView.isUserInteractionEnabled = true
        
        phoneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCallTap(tapGestureRecognizer:))))

        timeTableLabel.text = Config.timeTable
        phoneNumberLabel.text = Config.contactNumber
        phoneView.image = UIImage(named: "WhiteCard")
        
        infoLabel.isUserInteractionEnabled = true
        infoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEmailTap(tapGestureRecognizer:))))
        
    }
    
    @objc func onCallTap(tapGestureRecognizer: UITapGestureRecognizer) {
        open(phone: Config.contactNumber)
    }
    
    @objc func onEmailTap(tapGestureRecognizer: UITapGestureRecognizer) {
        let email = Config.contactEmail
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("<p></p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func loadTexts() {
        let attributedString = NSMutableAttributedString(string: "Muchas gracias por participar en el piloto de la APP Radar COVID, contándonos tu opinión de forma anónima nos ayuda a mejorar  y contribuir a prevenir futuros contagios.", attributes: [
          .font: UIFont(name: "Muli-Light", size: 16.0)!,
          .foregroundColor: UIColor(white: 0.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 16.0)!, range: NSRange(location: 66, length: 60))
        
        thanksLabel.attributedText = attributedString
        
        let attributedString2 = NSMutableAttributedString(string: "Contacta con nosotros si tu riesgo de exposición en la aplicación es alto o si tienes cualquier incidencia sobre la aplicación.", attributes: [
          .font: UIFont(name: "Muli-Light", size: 16.0)!,
          .foregroundColor: UIColor(white: 0.0, alpha: 1.0)
        ])
        attributedString2.addAttribute(.font, value: UIFont(name: "Muli-SemiBold", size: 16.0)!, range: NSRange(location: 22, length: 51))
        attributedString2.addAttribute(.font, value: UIFont(name: "Muli-SemiBold", size: 16.0)!, range: NSRange(location: 96, length: 10))
        
        reportLabel.attributedText = attributedString2
        
        let attributedString3 = NSMutableAttributedString(string: "Un paso más \n\n¿Te interesaría participar en una entrevista telefónica para conocer más sobre tu experiencia con Radar COVID? Escribe a:\npiloto.appcovid@economia.gob.es\n\nNos pondremos en contacto contigo para fijar el día y la hora que se adapte mejor a tí.", attributes: [
          .font: UIFont(name: "Muli-Light", size: 16.0)!,
          .foregroundColor: UIColor(white: 0.0, alpha: 1.0)
        ])
        attributedString3.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 18.0)!, range: NSRange(location: 0, length: 12))
        attributedString3.addAttribute(.font, value: UIFont(name: "Muli-Bold", size: 16.0)!, range: NSRange(location: 135, length: 32))
        attributedString3.addAttribute(.font, value: UIFont(name: "Muli-Light", size: 16.0)!, range: NSRange(location: 167, length: 87))
        infoLabel.attributedText = attributedString3
        
    }

}
