import 'package:flutter/material.dart';
import 'contact_model.dart';
import 'alphabet_scroller.dart';

class ContactListView extends StatefulWidget {
  final List<Contact> contacts;
  final Function(Contact) onContactSelected;
  final String? title;
  final bool Function(Contact)? filterPredicate;

  const ContactListView({
    super.key,
    required this.contacts,
    required this.onContactSelected,
    this.title,
    this.filterPredicate,
  });

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  late List<Contact> filteredContacts;
  late TextEditingController searchController;
  final ScrollController scrollController = ScrollController();
  String selectedLetter = '';
  bool filterHasPhone = false;
  bool filterHasEmail = false;

  @override
  void initState() {
    super.initState();
    print('ContactListView: Received ${widget.contacts.length} contacts.');
    searchController = TextEditingController();
    _applyFilters();
    searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      filteredContacts = widget.contacts.where((contact) {
        final matchesSearch = searchController.text.isEmpty ||
            contact.displayName
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            (contact.phoneNumber?.contains(searchController.text) ?? false);

        final matchesPredicate = widget.filterPredicate?.call(contact) ?? true;

        final matchesPhone = !filterHasPhone || (contact.phoneNumber != null && contact.phoneNumber!.isNotEmpty);
        final matchesEmail = !filterHasEmail || (contact.email != null && contact.email!.isNotEmpty);

        return matchesSearch && matchesPredicate && matchesPhone && matchesEmail;
      }).toList();
      
      filteredContacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    });
  }

  void _scrollToLetter(String letter) {
    setState(() {
      selectedLetter = letter;
    });
    final index = filteredContacts.indexWhere(
        (contact) => contact.displayName.toUpperCase().startsWith(letter));
    if (index != -1) {
      const itemHeight = 72.0;
      scrollController.animateTo(
        index * itemHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ#".split("");

    return Scaffold(
      appBar: widget.title != null ? AppBar(title: Text(widget.title!)) : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('With Phone'),
                  selected: filterHasPhone,
                  onSelected: (val) {
                    setState(() => filterHasPhone = val);
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('With Email'),
                  selected: filterHasEmail,
                  onSelected: (val) {
                    setState(() => filterHasEmail = val);
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: filteredContacts.isEmpty
              ? const Center(
                  child: Text(
                    'No contacts found matching your search.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Stack(
                  children: [
                    ListView.builder(
                  controller: scrollController,
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: contact.photoUrl != null
                            ? NetworkImage(contact.photoUrl!)
                            : null,
                        child: contact.photoUrl == null
                            ? Text(contact.initials)
                            : null,
                      ),
                      title: Text(contact.displayName),
                      subtitle: contact.phoneNumber != null
                          ? Text(contact.phoneNumber!)
                          : null,
                      onTap: () => widget.onContactSelected(contact),
                    );
                  },
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: AlphabetScroller(
                    alphabets: alphabets,
                    selectedLetter: selectedLetter,
                    onLetterSelect: _scrollToLetter,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
