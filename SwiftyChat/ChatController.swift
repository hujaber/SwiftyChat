//
//  ViewController.swift
//  ChatPrototype
//
//  Created by Hussein Jaber on 26/9/19.
//  Copyright © 2019 Hussein Jaber. All rights reserved.
//

import UIKit

struct Message {
    var text: String
    var isSender: Bool
    var isProperty: Bool = false
}

/// Defines the style of the controllers UI elements
public struct ChatStyle {
    // TextView
    /// The font of the chat text view
    public var textViewFont: UIFont = .systemFont(ofSize: 17, weight: .bold)
    
    /// Tint color (mainly to specify the cursor color)
    #warning("Fix color issues, systemRed is not supported by iOS < 13")
    public var textViewTintColor: UIColor = .systemRed
    
    /// Placeholder text color
    public var placeholderTextColor: UIColor = .lightGray
    
    // TableView
    /// Content inset of chat table view
    public var tableContentInset: UIEdgeInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
    /// Footer view of chat table view
    public var tableFooterView: UIView = .init()
    
    // Lower area
    /// Background color of the area holding a stackview (which holds a
    /// view and a send button)
    public var textAreaBackgroundColor: UIColor = .clear
    
    // StackView
    /// Spacing between elements inside stackview
    public var stackViewSpacing: CGFloat = 15
    
    // Send Button
    public var buttonImage: UIImage? = UIImage(named: "sendButton", in: Bundle(for: ChatViewController.self), compatibleWith: nil)
    
    public init() {}
}

/// Defines some options of the controller
public struct ChatOptions {
    public var hideKeyboardOnScroll: Bool = true
    
    public var hideKeyboardOnTableTap: Bool = true
}

/// View controller with the following hierachy:
/// - view
///     - UITableView
///     - UIStackView (horizontal)
///         - UITextView
///         - UIButton
open class ChatViewController: UIViewController {
    
    /// Chat controller style
    open var style: ChatStyle = .init()
    /// Chat controller options
    public var options: ChatOptions = .init()
    
    private var currentBundle: Bundle{
        return .init(for: Self.self)
    }
    
    // MARK: - Subviews
    
    /// Chat controller table view where the chat will be displayed
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    /// The area below the table view
    private let textAreaBackground = UIView()
    
    /// Horizontal StackView
    /// - Note: Holds initially a textview (where message is typed) and a send button
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.chatTextView, self.sendButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = self.style.stackViewSpacing
        return sv
    }()
    
    /// Text view where message is typed. Expandes with text height
    private lazy var chatTextView: UITextView = {
        let tf = UITextView()
        tf.textContainer.heightTracksTextView = true
        tf.tintColor = self.style.textViewTintColor
        tf.font = self.style.textViewFont
        tf.isScrollEnabled = false
        tf.delegate = self
        return tf
    }()
    
    /// Constraint between text area bottom and view bottom
    /// - NOTE: Initially is set to zero, changes when keyboard
    ///         appears/disappears
    private lazy var textAreaBottomConstraint: NSLayoutConstraint = {
        return self.textAreaBackground
            .bottomAnchor
            .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                        constant: 0)
    }()
    
    /// The button used to trigger the 'send message' action
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(self.style.buttonImage, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        return button
    }()
    
    var messages: [Message] = [Message(text: "Hello", isSender: true),
                               Message(text: "Hi", isSender: false) ,
                               .init(text: "I'm interested in your property", isSender: true),
                               .init(text: "So?", isSender: false),
                               
                               .init(text: "Alright, sounds great", isSender: true),
                               .init(text: "See you tomorrow, bye", isSender: false),
                               .init(text: "Bye", isSender: true),
                               .init(text: "Property", isSender: false, isProperty: true),
                               .init(text: "Oooo", isSender: true, isProperty: true)
    ]
        
    override public func viewDidLoad() {
        super.viewDidLoad()
        startObservingKeyboard()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defer {
            activateConstraints()
        }
        setupTableView()
        setupTextFieldArea()
        setupStackView()
        addPlaceHolderText()
    }
    
    /// Setup TableView and add it to view
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = style.tableContentInset
        tableView.tableFooterView = style.tableFooterView
        tableView.allowsSelection = false
        registerCells()
        if options.hideKeyboardOnTableTap {
            tableView.addGestureRecognizer(
                UITapGestureRecognizer(target: self,
                                       action: #selector(hideKeyboard)))
        }
        view.addSubview(tableView)
    }
    
    /// Register cells to tableview
    public func registerCells() {
        tableView.register(IncomingCell.self,
                           forCellReuseIdentifier: IncomingCell.identifier)
        tableView.register(OutgoingCell.self,
                           forCellReuseIdentifier: OutgoingCell.identifier)
        tableView.register(IncomingSharedPropertyCell.self,
                           forCellReuseIdentifier: IncomingSharedPropertyCell.identifier)
        tableView.register(OutgoingSharedProperty.self,
                           forCellReuseIdentifier: OutgoingSharedProperty.identifier)
    }
    
    /// Setup the lower area of the view
    private func setupTextFieldArea() {
        textAreaBackground.translatesAutoresizingMaskIntoConstraints = false
        textAreaBackground.backgroundColor = style.textAreaBackgroundColor
        
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lineView.backgroundColor = UIColor.systemGray4
        } else {
            lineView.backgroundColor = UIColor.darkGray
        }
        view.addSubview(textAreaBackground)
        textAreaBackground.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: textAreaBackground.leadingAnchor),
            lineView.topAnchor.constraint(equalTo: textAreaBackground.topAnchor),
            lineView.trailingAnchor.constraint(equalTo: textAreaBackground.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupStackView() {
        textAreaBackground.addSubview(stackView)
    }
    
    /// Activate constraints for all views
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: textAreaBackground.topAnchor),
            
            textAreaBackground.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            textAreaBackground.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            self.textAreaBottomConstraint,
            textAreaBackground.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            stackView.topAnchor.constraint(equalTo: textAreaBackground.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: textAreaBackground.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: textAreaBackground.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: textAreaBackground.trailingAnchor, constant: -10)
        ])
    }
    
    
    /// Hide keyboard
    @objc
    public func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    /// Action triggered when 'Send' button gets tapped
    @objc
    public func didTapSend() {
        if chatTextView.containsAtLeastACharacter {
            messages.append(.init(text: chatTextView.text, isSender: true))
            tableView.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .fade)
            scrollTableViewToLastRow()
        }
    }
    
    /// Scrolls table view to last row according to items in messages array
    public func scrollTableViewToLastRow() {
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        guard lastRow > 0 else { return }
        let lastIndexPath = IndexPath(row: lastRow, section: 0)
        tableView.scrollToRow(at: lastIndexPath, at: .top, animated: true)
    }
    
    /// Remove observers to avoid memory leaks
    deinit {
      let notificationCenter = NotificationCenter.default
      notificationCenter.removeObserver(
        self,
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
      notificationCenter.removeObserver(
        self,
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
    }
    
    /// Adds observers to changes in keyboard show/hide flags
    private func startObservingKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                       object: nil,
                                       queue: nil,
                                       using: keyboardWillAppear)
        
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil,
                                       queue: nil,
                                       using: keyboardWillDisappear)
    }
    
    /// Action done when keyboard will appear
    public func keyboardWillAppear(_ notification: Notification) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else {
          return
        }
        
        let safeAreaBottom = view.safeAreaLayoutGuide.layoutFrame.maxY
        let viewHeight = view.bounds.height
        let safeAreaOffset = viewHeight - safeAreaBottom
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.textAreaBottomConstraint.constant = -keyboardFrame.height + safeAreaOffset                
                self.view.layoutIfNeeded()
                self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .top, animated: true)
        })
    }
    
    
    public func keyboardWillDisappear(_ notification: Notification) {
        UIView.animate(
          withDuration: 0.3,
          delay: 0,
          options: [.curveEaseInOut],
          animations: {
            self.textAreaBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }


}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.isSender {
            if message.isProperty {
                let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingSharedProperty.identifier, for: indexPath) as! OutgoingSharedProperty
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingCell.identifier, for: indexPath) as! OutgoingCell
                cell.setup(text: message.text)
                return cell
            }
            
        } else {
            if message.isProperty {
                let cell = tableView.dequeueReusableCell(withIdentifier: IncomingSharedPropertyCell.identifier, for: indexPath) as! IncomingSharedPropertyCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: IncomingCell.identifier, for: indexPath) as! IncomingCell
                cell.setup(text: messages[indexPath.row].text)
                return cell
            }
        }
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

extension ChatViewController: UITextViewDelegate {
    
    /// Changes color of textview text to appear like a placeholder.
    public func addPlaceHolderText(text: String = "Type in your message") {
        chatTextView.text = text
        chatTextView.textColor = style.placeholderTextColor
    }
    
    public func removePlaceholderText() {
        self.chatTextView.text = nil
        if #available(iOS 13.0, *) {
            self.chatTextView.textColor = .label
        } else {
            self.chatTextView.textColor = .black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            addPlaceHolderText()
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        removePlaceholderText()
    }
}

extension UITextView {
    /// Ensures contains at least one character (not accounting
    /// spaces/new line breaks)
    var containsAtLeastACharacter: Bool {
        return !self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


