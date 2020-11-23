# SwiftyChat
A chat controller written in Swift

# Usage
1. Import SwiftyChat
2. Create a new view controller and make it a subclass of ChatViewController
3. Run your app and try it out!

# Style
You can set your own style instead of that comes by default by assigning the controllers.

You can customize the following:

1. Typing area font: 
    ```
    self.style.textViewFont = .systemFont(ofSize: 12, weight: .regular)
    ```
2. Typing area tint color: use this to customize the cursor color 
    ```
    self.style.textViewTintColor = .black
    ```
3. Placeholder text color:
    ```
    self.style.placeholderTextColor = .lightGray
    ```
4. Text area background color:
    ```
    self.style.textAreaBackgroundColor = .white
    ```

You can also change the send buttons image, the table footer view etc..

# Options
You can change these options if you prefer:
1. Hiding the keyboard on scroll (defaults to `true`):
    ```
    self.options.hideKeyboardOnScroll = false
    ```
2. Hiding keyboard when tapping the table view (defaults to `true`):
    ```
    self.options.hideKeyboardOnTableTap = false
    ```
    
    
