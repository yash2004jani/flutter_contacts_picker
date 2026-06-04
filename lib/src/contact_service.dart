import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'contact_model.dart';

class ContactService {
  static Future<List<Contact>> getMobileContacts() async {
    print('ContactService: Checking current permission status...');
    
    bool permission = await fc.FlutterContacts.requestPermission(readonly: true);
    print('ContactService: Permission status (readonly: true): $permission');
    
    if (!permission) {
      permission = await fc.FlutterContacts.requestPermission();
      print('ContactService: Permission status (standard): $permission');
    }
    
    if (!permission) {
      print('ContactService: Permission STUCK as denied.');
      throw Exception('Permission denied: Android reports "denied". Please check App Info > Permissions.');
    }

    print('ContactService: Permission confirmed. Fetching...');
    try {
      final rawContacts = await fc.FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: false,
      );
      
      print('ContactService: getContacts returned ${rawContacts.length} items.');
      
      return rawContacts.map((c) {
        return Contact(
          displayName: c.displayName,
          phoneNumber: c.phones.isNotEmpty ? c.phones.first.number : null,
          email: c.emails.isNotEmpty ? c.emails.first.address : null,
        );
      }).toList();
    } catch (e) {
      print('ContactService: Error fetching: $e');
      throw Exception('Failed to fetch contacts: ${e.toString()}');
    }
  }
}
