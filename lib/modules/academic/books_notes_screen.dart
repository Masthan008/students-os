import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BooksNotesScreen extends StatefulWidget {
  const BooksNotesScreen({super.key});

  @override
  State<BooksNotesScreen> createState() => _BooksNotesScreenState();
}

class _BooksNotesScreenState extends State<BooksNotesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Books & Notes',
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyanAccent,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.book), text: 'Books'),
            Tab(icon: Icon(Icons.note), text: 'Notes'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade900,
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search books or notes...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _BooksTab(searchQuery: _searchQuery),
                _NotesTab(searchQuery: _searchQuery),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddBookDialog();
          } else {
            _showAddNoteDialog();
          }
        },
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: Text(_tabController.index == 0 ? 'Add Book' : 'Add Note'),
      ),
    );
  }

  void _showAddBookDialog() {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final linkController = TextEditingController();
    String selectedSubject = 'General';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text('Add Book', style: GoogleFonts.orbitron(color: Colors.cyanAccent)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Book Title',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: authorController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Author',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: linkController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'PDF Link (Optional)',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setDialogState) => DropdownButtonFormField<String>(
                  value: selectedSubject,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                  items: ['General', 'Mathematics', 'Physics', 'Chemistry', 'Computer Science', 'English', 'Other']
                      .map((subject) => DropdownMenuItem(value: subject, child: Text(subject)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedSubject = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final box = Hive.box('books_notes');
                final books = List<Map<String, dynamic>>.from(box.get('books', defaultValue: []));
                books.add({
                  'id': DateTime.now().millisecondsSinceEpoch,
                  'title': titleController.text,
                  'author': authorController.text,
                  'link': linkController.text,
                  'subject': selectedSubject,
                  'createdAt': DateTime.now().toIso8601String(),
                });
                box.put('books', books);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book added successfully')),
                );
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedSubject = 'General';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text('Add Note', style: GoogleFonts.orbitron(color: Colors.cyanAccent)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Note Title',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setDialogState) => DropdownButtonFormField<String>(
                  value: selectedSubject,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                  items: ['General', 'Mathematics', 'Physics', 'Chemistry', 'Computer Science', 'English', 'Other']
                      .map((subject) => DropdownMenuItem(value: subject, child: Text(subject)))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedSubject = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                final box = Hive.box('books_notes');
                final notes = List<Map<String, dynamic>>.from(box.get('notes', defaultValue: []));
                notes.add({
                  'id': DateTime.now().millisecondsSinceEpoch,
                  'title': titleController.text,
                  'content': contentController.text,
                  'subject': selectedSubject,
                  'createdAt': DateTime.now().toIso8601String(),
                });
                box.put('notes', notes);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note added successfully')),
                );
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }
}

// ============================================
// Books Tab
// ============================================
class _BooksTab extends StatefulWidget {
  final String searchQuery;

  const _BooksTab({required this.searchQuery});

  @override
  State<_BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<_BooksTab> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('books_notes').listenable(),
      builder: (context, box, _) {
        final books = List<Map<String, dynamic>>.from(box.get('books', defaultValue: []));
        
        final filteredBooks = widget.searchQuery.isEmpty
            ? books
            : books.where((book) {
                final title = book['title'].toString().toLowerCase();
                final author = book['author'].toString().toLowerCase();
                final subject = book['subject'].toString().toLowerCase();
                return title.contains(widget.searchQuery) ||
                    author.contains(widget.searchQuery) ||
                    subject.contains(widget.searchQuery);
              }).toList();

        if (filteredBooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, size: 64, color: Colors.grey.shade700),
                const SizedBox(height: 16),
                Text(
                  widget.searchQuery.isEmpty ? 'No books added yet' : 'No books found',
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.searchQuery.isEmpty ? 'Tap + to add your first book' : 'Try a different search',
                  style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            final book = filteredBooks[index];
            return _buildBookCard(book);
          },
        );
      },
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final hasLink = book['link'] != null && book['link'].toString().isNotEmpty;

    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: hasLink ? () => _openLink(book['link']) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.book, color: Colors.cyanAccent, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['title'],
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (book['author'].toString().isNotEmpty)
                          Text(
                            'by ${book['author']}',
                            style: GoogleFonts.montserrat(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    color: Colors.grey.shade800,
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    itemBuilder: (context) => [
                      if (hasLink)
                        const PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              Icon(Icons.open_in_new, color: Colors.cyanAccent, size: 20),
                              SizedBox(width: 8),
                              Text('Open Link', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'open') {
                        _openLink(book['link']);
                      } else if (value == 'delete') {
                        _deleteBook(book['id']);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.orange.withOpacity(0.5)),
                    ),
                    child: Text(
                      book['subject'],
                      style: GoogleFonts.montserrat(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (hasLink)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link, color: Colors.green, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'PDF Available',
                            style: GoogleFonts.montserrat(
                              color: Colors.green,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  void _deleteBook(int id) {
    final box = Hive.box('books_notes');
    final books = List<Map<String, dynamic>>.from(box.get('books', defaultValue: []));
    books.removeWhere((book) => book['id'] == id);
    box.put('books', books);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book deleted')),
    );
  }
}

// ============================================
// Notes Tab
// ============================================
class _NotesTab extends StatefulWidget {
  final String searchQuery;

  const _NotesTab({required this.searchQuery});

  @override
  State<_NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<_NotesTab> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('books_notes').listenable(),
      builder: (context, box, _) {
        final notes = List<Map<String, dynamic>>.from(box.get('notes', defaultValue: []));
        
        final filteredNotes = widget.searchQuery.isEmpty
            ? notes
            : notes.where((note) {
                final title = note['title'].toString().toLowerCase();
                final content = note['content'].toString().toLowerCase();
                final subject = note['subject'].toString().toLowerCase();
                return title.contains(widget.searchQuery) ||
                    content.contains(widget.searchQuery) ||
                    subject.contains(widget.searchQuery);
              }).toList();

        if (filteredNotes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.note_outlined, size: 64, color: Colors.grey.shade700),
                const SizedBox(height: 16),
                Text(
                  widget.searchQuery.isEmpty ? 'No notes added yet' : 'No notes found',
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.searchQuery.isEmpty ? 'Tap + to add your first note' : 'Try a different search',
                  style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            final note = filteredNotes[index];
            return _buildNoteCard(note);
          },
        );
      },
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _viewNote(note),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.note, color: Colors.purple, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      note['title'],
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    color: Colors.grey.shade800,
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, color: Colors.cyanAccent, size: 20),
                            SizedBox(width: 8),
                            Text('View', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'view') {
                        _viewNote(note);
                      } else if (value == 'delete') {
                        _deleteNote(note['id']);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                note['content'],
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue.withOpacity(0.5)),
                ),
                child: Text(
                  note['subject'],
                  style: GoogleFonts.montserrat(
                    color: Colors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewNote(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          note['title'],
          style: GoogleFonts.orbitron(color: Colors.cyanAccent),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue.withOpacity(0.5)),
                ),
                child: Text(
                  note['subject'],
                  style: GoogleFonts.montserrat(
                    color: Colors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                note['content'],
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  void _deleteNote(int id) {
    final box = Hive.box('books_notes');
    final notes = List<Map<String, dynamic>>.from(box.get('notes', defaultValue: []));
    notes.removeWhere((note) => note['id'] == id);
    box.put('notes', notes);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note deleted')),
    );
  }
}
