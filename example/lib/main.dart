import 'package:flutter/material.dart';
import 'package:flutter_contacts_picker/flutter_contacts_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts Picker',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  List<Contact> _contacts = [];
  bool _isLoading = false;
  String? _errorMessage;
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      var contacts = await ContactService.getMobileContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ContactListView(
            title: 'Select a Contact',
            contacts: _contacts,
            onContactSelected: (contact) {
              setState(() {
                _selectedContact = contact;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Picker'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadContacts),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage != null) ...[
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (_selectedContact != null) ...[
                      const Text(
                        'Selected Contact:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(_selectedContact!.initials),
                          ),
                          title: Text(_selectedContact!.displayName),
                          subtitle: Text(
                              _selectedContact!.phoneNumber ?? 'No number'),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    ElevatedButton.icon(
                      onPressed: _showPicker,
                      icon: const Icon(Icons.person_search),
                      label: const Text('Open Contacts Picker'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Contacts found: ${_contacts.length}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (_contacts.isEmpty && _errorMessage == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'Your device address book is currently empty.\nPlease add a contact in your phone settings to test real data.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
