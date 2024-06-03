//
//  VerSnapViewController.swift
//  OlivaresSnapchat
//
//  Created by Nicolas Palma on 3/06/24.
//

import UIKit

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!
    var snap = Snap()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
    }

}
