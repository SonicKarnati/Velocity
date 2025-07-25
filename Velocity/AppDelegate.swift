import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    // The status bar item that holds our menu bar icon and menu
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        // Create the menu bar icon using the Pixellari font
        if let button = statusItem.button {
            // Use an attributed string for better control over alignment and appearance
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // Load the custom Pixellari font
            if let font = loadCustomFont(fontName: "Pixellari", fontExtension: "ttf", fontSize: 16) {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .paragraphStyle: paragraphStyle,
                    .baselineOffset: -1 // Revert baseline to visually center the 'V'
                ]
                let attributedTitle = NSAttributedString(string: "V", attributes: attributes)
                button.attributedTitle = attributedTitle
            } else {
                // Fallback to a default "V" if the font fails to load
                button.title = "V"
            }
        }

        // Create the menu that appears when the icon is clicked
        constructMenu()

        // Hide the app from the Dock
        NSApp.setActivationPolicy(.accessory)
    }

    // This function creates and attaches the menu to the status bar item.
    func constructMenu() {
        let menu = NSMenu()

        // Add a "Settings" menu item
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(settingsClicked(_:)), keyEquivalent: ","))
        // Add a "Quit" menu item
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    // Action for the "Settings" menu item.
    @objc func settingsClicked(_ sender: Any?) {
        // This is where you would open a settings window or perform an action.
        print("Settings clicked!")
    }

    // This function handles loading a custom font.
    func loadCustomFont(fontName: String, fontExtension: String, fontSize: CGFloat) -> NSFont? {
        print("Attempting to load font: \(fontName).\(fontExtension)")
        // Get the URL for the font file in the app's bundle.
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: fontExtension) else {
            print("Error: Font file '\(fontName).\(fontExtension)' not found in the app bundle.")
            return nil
        }
        print("Font URL found: \(fontURL.lastPathComponent)")

        // Create a CGDataProvider from the font URL.
        guard let dataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("Error: Could not create data provider for font.")
            return nil
        }
        print("CGDataProvider created.")

        // Create a CGFont from the data provider.
        guard let cgFont = CGFont(dataProvider) else {
            print("Error: Could not create CGFont from data provider.")
            return nil
        }
        print("CGFont created.")

        // Register the font with the system.
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(cgFont, &error) {
            print("Error: Could not register font. \(error!.takeRetainedValue())")
            return nil
        }
        print("Font registered successfully.")

        // Return the NSFont instance. The postscript name might be different from the file name.
        // For Pixellari.ttf, the postscript name is typically "Pixellari".
        let postscriptName = cgFont.postScriptName as String? ?? fontName // Get actual postscript name
        print("Attempting to create NSFont with PostScript name: \(postscriptName)")
        return NSFont(name: postscriptName, size: fontSize)
    }

    
}
