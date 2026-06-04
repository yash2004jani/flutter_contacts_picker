import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_contacts_picker/flutter_contacts_picker.dart';

void main() {
  final List<Contact> mockContacts = [
    Contact(displayName: 'Alice', phoneNumber: '123'),
    Contact(displayName: 'Bob', phoneNumber: '456'),
    Contact(displayName: 'Charlie', phoneNumber: '789'),
  ];

  testWidgets('ContactListView shows all contacts initially', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactListView(
        contacts: mockContacts,
        onContactSelected: (_) {},
      ),
    ));

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Charlie'), findsOneWidget);
  });

  testWidgets('ContactListView filters contacts by name', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactListView(
        contacts: mockContacts,
        onContactSelected: (_) {},
      ),
    ));

    await tester.enterText(find.byType(TextField), 'Al');
    await tester.pump();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsNothing);
    expect(find.text('Charlie'), findsNothing);
  });

  testWidgets('ContactListView filters contacts by phone number', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactListView(
        contacts: mockContacts,
        onContactSelected: (_) {},
      ),
    ));

    await tester.enterText(find.byType(TextField), '456');
    await tester.pump();

    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Alice'), findsNothing);
    expect(find.text('Charlie'), findsNothing);
  });

  testWidgets('ContactListView applies initial filterPredicate', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContactListView(
        contacts: mockContacts,
        onContactSelected: (_) {},
        filterPredicate: (contact) => contact.displayName.startsWith('A'),
      ),
    ));

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsNothing);
    expect(find.text('Charlie'), findsNothing);
  });
}
