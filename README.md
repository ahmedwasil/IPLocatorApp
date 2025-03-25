# IP Locator App

This is a small SwiftUI app I built as part of a tech test. It lets you enter an IP address (or fetch your current one), looks up its approximate location using an API, and then drops a pin on the map.

---

## 🌍 What it does

- Enter any IPv4 address (like `8.8.8.8`)
- Or just tap a "Get My IP" button to get your current public IP
- Uses [ipapi.co](https://ipapi.co) to fetch location details
- Shows the result on a map using MapKit
- Handles loading states, errors, and invalid IPs

---

## ⚙️ How it's built

I went with a **SwiftUI + Combine** setup using the **MVVM architecture**. It’s reactive, clean, and easy to test.

The networking logic is abstracted using a protocol (`IPServiceProtocol`) so I can mock it in unit tests and swap out services easily.

I also added basic error handling, loading indicators, and IP validation to keep things tidy and user-friendly.

---

## 🧪 Tests

There are unit tests for the `IPViewModel`, using a mock network service to simulate API responses.

Tests cover:
- Invalid IP errors
- Valid IP location success
- IP auto-fetch fallback

You can run them with `Cmd + U` in Xcode.

---

## 📦 Tech used

- SwiftUI
- Combine
- MapKit
- MVVM architecture
- Dependency Injection
- ipapi.co (free geolocation API)

---

## 💡 If I had more time...

- Support IPv6
- Add a history of searched IPs
- Fallback to user GPS if IP lookup fails
- Nicer UI styling and animations (FYI UI was not the focus for this task)
- Add further for Failing Mock Case, View Model State, UI Tests, Network Service Tests

---

## 🙌 Thanks!

Let me know if you'd like a walkthrough or if there's anything you'd like to see improved or expanded!

