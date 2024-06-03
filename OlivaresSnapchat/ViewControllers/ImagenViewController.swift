//
//  ImagenViewController.swift
//  OlivaresSnapchat
//
//  Created by Carlos Erickson Olivares Conza on 27/05/24.
//

import UIKit
import Firebase

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        guard let imagenData = imageView.image?.jpegData(compressionQuality: 0.50) else {
            self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener la imagen.", accion: "Aceptar")
            self.elegirContactoBoton.isEnabled = true
            return
        }
        
        let cargarImagen = imagenesFolder.child("\(NSUUID().uuidString).jpg")
        cargarImagen.putData(imagenData, metadata: nil) { (metadata, error) in
            if let error = error {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrió un error al subir imagen: \(error)")
                return
            } else {
                cargarImagen.downloadURL(completion: { (url, error) in
                    if let error = error {
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener información de imagen.", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrió un error al obtener información de imagen: \(error)")
                        return
                    }
                    
                    guard let enlaceURL = url else {
                        self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener la URL de la imagen.", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        return
                    }
                    
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: enlaceURL.absoluteString)
                })
            }
        }
    }

        /*
        let alertaCarga = UIAlertController(title: "Cargando Imagen...", message: "0%", preferredStyle: .alert)
        let progresoCarga: UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) { (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            progresoCarga.setProgress(Float(porcentaje), animated: true)
            progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 8)
            alertaCarga.message = String(round(porcentaje * 100.0)) + "%"
            if porcentaje >= 1.0 {
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        alertaCarga.view.addSubview(progresoCarga)
        present(alertaCarga, animated: true, completion: nil)

    }
*/

    
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
    }

    func mostrarAlerta (titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController (title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction (title: accion, style: .default, handler: nil)
        alerta.addAction (btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }


}
		
