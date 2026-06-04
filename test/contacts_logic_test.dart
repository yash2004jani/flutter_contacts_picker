import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_contacts_picker/src/contact_model.dart';

void main() {
  group('Contact Model Tests', () {
    test('initials should be correct for single name', () {
      final contact = Contact(displayName: 'John');
      expect(contact.initials, 'J');
    });

    test('initials should be correct for double name', () {
      final contact = Contact(displayName: 'John Doe');
      expect(contact.initials, 'JD');
    });

    test('initials should be correct for triple name', () {
      final contact = Contact(displayName: 'John Quincy Adams');
      expect(contact.initials, 'JA');
    });

    test('initials should handle trailing spaces', () {
      final contact = Contact(displayName: ' John Doe ');
      expect(contact.initials, 'JD');
    });
  });
}
