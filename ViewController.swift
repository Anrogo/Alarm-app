//
//  ViewController.swift
//  Alarm
//
//  Created by user190722 on 1/30/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var currentHour: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Grant to show notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Permiso concedido")
            } else {
                print("Permiso denegado")
                print(error)
            }
        }
        
        //Update the hour
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showDate), userInfo: nil, repeats: true)
        
        //Close keyboard when finish to write
        self.textField.delegate = self
        
    }

    @IBAction func start(_ sender: UIButton) {
        let time = Int(self.textField.text ?? "Error")!
        
        if time > 0 {
            DispatchQueue.global().async {
                for n in stride(from: time, through: 0, by: -1){
                    sleep(1)
                    DispatchQueue.main.async{
                        self.updateLabel(value: String(n))
                    }
                    print(n)
                }
                self.showNotification()
            }
        }
    }
    
    func updateLabel(value: String){
        self.textField.text = value
    }
    
    func showNotification() {
        //Crear contenido notificación
        let content = UNMutableNotificationContent()
        content.title = "Alarma"
        content.subtitle = "Son las " + self.showHour()
        content.body = "Despierta de una vez holgazán!!"
        content.sound = .default
        
        //Definir disparador
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        //Pedir lanzamiento
        let request = UNNotificationRequest(identifier: "notificacionId", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) {
            (error) in print(error)
        }
    }
   
    @objc func showDate(){
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
         
        let hour = calendar.component(.hour, from: date)+1
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
         
        var strDay:String = ""
        var strMonth:String = ""
        let strYear:String = String(year)
        var strHour:String = ""
        var strMinute:String = ""
        var strSecond:String = ""
         
        //Forma 1 de anteponer un cero
        if day < 10{
            strDay = "0" + String(day)
        } else {
            strDay = String(day)
        }
         
        //Forma 2 de anteponer un cero
        strMonth = String(format: "%02d", month)
        strHour = String(format: "%02d", hour)
        strMinute = String(format: "%02d", minute)
        strSecond = String(format: "%02d", second)
         
       // self.lblHora.text = ;
        
        self.currentHour.text = strDay + "-" + strMonth + "-" + strYear + " " + strHour + ":" + strMinute+":"+strSecond
    }
    
    func showHour() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)+1
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        var strHour:String = ""
        var strMinute:String = ""
        var strSecond:String = ""
        strHour = String(format: "%02d", hour)
        strMinute = String(format: "%02d", minute)
        strSecond = String(format: "%02d", second)
        return strHour + ":" + strMinute + ":" + strSecond
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}

