//
//  AddVC.swift
//  Free-Adds
//
//  Created by Amin on 26/11/2023.
//

import UIKit
import Combine
class AddVC: UIViewController {
    
    @IBOutlet private weak var uiImageView: UIView!
    @IBOutlet private weak var uiTextfield: UITextField!
    @IBOutlet private weak var uiUploadView: UIView!
    @IBOutlet private weak var uiSelectedImage: UIImageView!
    @IBOutlet private weak var uiCreatButton: UIButton!
    private var viewModel: AddViewModelInterface
    private var cancellables: Set<AnyCancellable> = []
    let imagePicker = UIImagePickerController()
    
    init(viewModel: AddViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupView()
    }
    
    private func bind() {
        viewModel.validAd.sink { isValid in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10) {
                if isValid {
                    self.uiCreatButton.isHidden = false
                    self.uiCreatButton.alpha = 1
                } else {
                    if self.uiCreatButton.isHidden == false {
                        self.uiCreatButton.isHidden = true
                        self.uiCreatButton.alpha = 0
                    }
                }
            }
        }.store(in: &cancellables)
    }
    private func setupView() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        setupNavigationItem()
        setupPickerView()
    }
    private func setupPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        uiTextfield.inputView = pickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        uiTextfield.inputAccessoryView = toolbar
        
    }
    private func setupNavigationItem() {
        navigationItem.hidesBackButton = true
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = back
        navigationItem.title = "Create Free Ad For 24H"
    }
    func pickImage() {
        let alert = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .accent
        // Add option to choose from photo library
        let photoLibrary = UIAlertAction(
            title: "Photo Library",
            style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        alert.addAction(photoLibrary)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.showImagePicker(sourceType: .camera)
            }
            alert.addAction(camera)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func backTapped() {
        viewModel.backTapped.send()
    }
    @IBAction func selectCategoryTapped(_ sender: UIButton) {
        
    }
    @IBAction func uiUploadImage(_ sender: UIButton) {
        pickImage()
    }
    @IBAction func uiDeleteImage(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.uiImageView.isHidden = true
            self.uiImageView.alpha = 0
            self.viewModel.selectedImage.send(nil)
        }
    }
    
    @IBAction func uiCreateTapped(_ sender: UIButton) {
        viewModel.onCreatTapped.send()
    }
}
// MARK: - UIIMagePickerDelegate
extension AddVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            if pickedImage.size.width > 1080 || pickedImage.size.height > 1920 {
                showError(message: "Selected image dimensions are too large. Please choose a smaller image.") {
                    self.dismiss(animated: true)
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 10) {
                    self.uiImageView.isHidden = false
                    self.uiSelectedImage.image = pickedImage
                    self.uiImageView.alpha = 1
                    if let imageData = pickedImage.jpegData(compressionQuality: 1) {
                        self.viewModel.selectedImage.send(imageData)
                    } else {
                        // Handle the case where converting the image to data failed
                    }
                }
                
            }
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UIPickerDelegate
extension AddVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.categories.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.categories.value[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = viewModel.categories.value[row]
        viewModel.selectCategory.send(selected)
        uiTextfield.text = selected
    }
    
    // MARK: - Helper methods
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
}
