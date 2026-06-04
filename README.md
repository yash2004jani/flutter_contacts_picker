# 📱 Flutter Contacts Picker

A high-performance, feature-rich contact selection library for Flutter. This library provides a seamless experience for picking contacts with built-in support for search, fast alphabet scrolling, and advanced filtering.

Ideal for modern communication apps and social platforms that require an intuitive and efficient way to navigate large address books.

## ✨ Features

*   **🟢 Real-time Search**: Instant filtering by name or phone number with high-performance results.
*   **🔄 Fast Alphabet Scroller**: A vertical A-Z navigation bar for jumping directly to any contact section instantly.
*   **🎯 Advanced Filtering**: Built-in support for filtering contacts (e.g., "With Phone", "With Email") plus custom predicate support.
*   **📱 Mobile Integration**: Seamlessly fetches real device contacts across Android and iOS with automatic permission handling.
*   **⚡ High Performance**: Optimized for large address books (1,000+ contacts) with smooth 60fps scrolling and lazy-loaded initials.
*   **🧩 Clean & Lightweight**: Minimal dependencies and easy-to-integrate API for rapid development.

## Preview
![contact picker.gif](assets/video/contact%20picker.gif)

## 📁 Folder Structure

```text
flutter_contacts_picker/
│
├── lib/
│   ├── flutter_contacts_picker.dart  # Main Export API
│   └── src/
│       ├── alphabet_scroller.dart    # A-Z Navigation UI
│       ├── contact_list_view.dart    # Main Picker Widget
│       ├── contact_model.dart        # Data Models
│       └── contact_service.dart      # Permission & Fetching Logic
│
├── example/
│   └── lib/main.dart                 # Complete Demo Application
│
└── README.md
```

## 🚀 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_contacts_picker:
    path: https://github.com/yash2004jani/flutter_contacts_picker/tree/stagies.git
```

Then Run:

```bash
flutter pub get
```

## 🚀 Usage

### Simple Contact Picking

```dart
import 'package:flutter_contacts_picker/flutter_contacts_picker.dart';

Future<void> _onPickContact() async {
  // 1. Fetch contacts from the device
  List<Contact> contacts = await ContactService.getMobileContacts();

  // 2. Show the picker
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ContactListView(
        title: 'Select Contact',
        contacts: contacts,
        onContactSelected: (Contact contact) {
          print("Selected: ${contact.displayName}");
          Navigator.pop(context);
        },
      ),
    ),
  );
}
```

### Custom Filtering

```dart
ContactListView(
  contacts: myContacts,
  onContactSelected: (contact) => print(contact.displayName),
  // Optional: Only show contacts whose name starts with 'A'
  filterPredicate: (contact) => contact.displayName.startsWith('A'),
)
```

## 📜 License

MIT License

Copyright (c) 2026 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
