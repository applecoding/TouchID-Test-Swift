//
//  ViewController.swift
//  TouchID Test Swift
//
//  Created by Julio César Fernández Muñoz on 20/01/15.
//  Copyright (c) 2015 Gabhel Studios. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var usuario = "Paco"
    var pass = "G0hg6Q"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pulsoBoton(sender: UIButton) {
        if userField.text == usuario && passwordField.text == pass {
            self.showOK()
        } else {
            self.showNOOK()
        }
    }
    
    @IBAction func quieroHuella(sender: UIButton) {
        if sePuedeUsarHuella() {
            self.comprobarHuella()
        }
    }
    
    func sePuedeUsarHuella() -> Bool {
        let contexto = LAContext()
        var error: NSError?
        
        if contexto.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            println("TouchID disponible.")
            return true
        } else {
            switch error!.code {
            case LAError.TouchIDNotEnrolled.rawValue:
                println("TouchID aun no configurado.")
            case LAError.PasscodeNotSet.rawValue:
                println("No se ha configurado un passcode en este dispositivo.")
            default:
                println("TouchID no está disponible en este dispositivo")
            }
            println(error?.localizedDescription)
            return false
        }
    }
    
    func comprobarHuella() {
        let contexto = LAContext()
        
        [contexto.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Por favor, valide el acceso con su huella",
            reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if success {
                    self.showOK()
                } else {
                    println(evalPolicyError?.localizedDescription)
                    switch evalPolicyError!.code {
                    case LAError.UserCancel.rawValue:
                        println("Autenticación cancelada por el usuario.")
                    case LAError.UserFallback.rawValue:
                        println("El usuario prefiere poner la clave.")
                    case LAError.SystemCancel.rawValue:
                        println("Autenticación cancelada por el sistema.")
                    default:
                        println("Autenticación errónea.")
                    }
                    self.showNOOK()
                }
        })]
    }

    
    func showOK() {
        var alert : UIAlertView = UIAlertView(title: "Entrada correcta", message: "Se ha validado correctamente el usuario", delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }

    func showNOOK() {
        var alert : UIAlertView = UIAlertView(title: "Entrada incorrecta", message: "No se ha validado el acceso del usuario", delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    
}

