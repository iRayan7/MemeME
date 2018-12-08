//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Rayan Aldafas on 19/11/2018.
//  Copyright © 2018 RayanAldafas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraPickerButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable the button if the device doesn't have a camera "a simulator for example"
        cameraPickerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // setting the textFields
        setTextAttributes(textField: topTextfield)
        setTextAttributes(textField: bottomTextfield)
        
    }
    
    
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : NSNumber(value: -3.0)
    ]
    
    // set textField attributes
    func setTextAttributes(textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
       showImagePicker(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        showImagePicker(source: .camera)
    }
    
    func showImagePicker(source : UIImagePickerController.SourceType) {
        let cameraPickerController = UIImagePickerController()
        cameraPickerController.delegate = self
        // changing the pickerController to a camera or album
        cameraPickerController.sourceType = source
        present(cameraPickerController, animated: true, completion: nil)
    }

    
    // UIImagePickerControllerDelegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        // dismiss after choosing the image
        dismiss(animated: true, completion: nil)
        
    }

    
    // clear teatField when clicked to be edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    // dismiss keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //shifts the view's y axis if the keyboard will open
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextfield.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //shifts the view back to the normal y axis if the keyboard is about to be dismissed
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }

    
    // returns the keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
    }
    
    // observe the keyboard events when open and closed
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    // remove observed keyboard events
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    func save() {
        let memedImage = generateMemedImage()
    
        // Create the meme
        var meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: imagePickerView.image!, memedImage: memedImage
        )
        
        // add the meme to memes array on the application deletage
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
        print("////////////\((UIApplication.shared.delegate as! AppDelegate).memes.count)//////////")

    }

    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false

        
        return memedImage
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        let meme = generateMemedImage()
        let items = [meme]
        let shareActivityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        
        shareActivityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                // save the image
                self.save()
                // dismiss the viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(shareActivityController, animated: true)
        
        // shareActivityController.completionWithItemsHandler = save()
    }
    
    // hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

