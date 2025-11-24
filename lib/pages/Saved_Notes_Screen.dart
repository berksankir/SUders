import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF135BEC);
    const bgLight = Color(0xFFF6F6F8);
    const bgDark = Color(0xFF101622);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Notes',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
        scaffoldBackgroundColor: bgLight,
        textTheme: const TextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark),
        scaffoldBackgroundColor: bgDark,
        textTheme: const TextTheme(),
      ),
      home: const MyNotesPage(),
    );
  }
}

class MyNotesPage extends StatefulWidget {
  const MyNotesPage({super.key});

  @override
  State<MyNotesPage> createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage> {
  String _toggle = 'Folders'; // "All Notes" | "Folders"
  final TextEditingController _search = TextEditingController();

  // State variables for folders
  List<_Folder> _allFolders = []; // The master list of folders
  List<_Folder> _filteredFolders = []; // The list displayed after filtering

  // State variable for all notes combined
  List<_Note> _allNotes = []; // All notes from all folders, sorted by lastModified

  bool _isFoldersInitialized = false; // Flag to prevent re-initialization

  @override
  void initState() {
    super.initState();
    // Listen for changes in the search input to filter folders
    _search.addListener(_filterFolders);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFoldersInitialized) {
      _initializeAllFolders();
      _filterFolders(); // Perform initial filtering after folders are initialized
      _updateAllNotesList(); // Initialize the combined all notes list
      _isFoldersInitialized = true;
    }
  }

  void _initializeAllFolders() {
    _allFolders = <_Folder>[
      _Folder(
        'CS 310',
        locked: true,
        color: Theme.of(context).colorScheme.primary,
        notes: <_Note>[
          _Note(
              title: 'Assignment 1',
              content: 'Complete Chapter 1 exercises on data structures.',
              lastModified: DateTime(2023, 10, 26, 10, 0)),
          _Note(
              title: 'Midterm Study Guide',
              content: 'Review all topics from week 1-5, focusing on algorithms.',
              lastModified: DateTime(2023, 10, 25, 14, 30)),
          _Note(
              title: 'Lecture Notes - Week 6',
              content: 'Concurrency and threading concepts in Java.',
              lastModified: DateTime(2023, 10, 24, 9, 0)),
          _Note(
              title: 'Project Idea',
              content: 'Develop a small command-line utility in C++.',
              lastModified: DateTime(2023, 10, 23, 18, 0)),
        ],
      ),
      _Folder(
        'MKTG 201',
        color: const Color(0xFF9C27B0),
        notes: <_Note>[
          _Note(
              title: 'Project Proposal',
              content: 'Submit proposal for new product launch campaign.',
              lastModified: DateTime(2023, 10, 27, 11, 0)),
          _Note(
              title: 'Reading: Chapter 7',
              content: 'Marketing strategies and consumer behavior analytics.',
              lastModified: DateTime(2023, 10, 26, 16, 0)),
          _Note(
              title: 'Case Study Prep',
              content: 'Analyze Nike\'s digital marketing approach.',
              lastModified: DateTime(2023, 10, 25, 12, 0)),
        ],
      ),
      _Folder(
        'SPS 101',
        color: const Color(0xFF4CAF50),
        notes: <_Note>[
          _Note(
              title: 'Lab Report 3',
              content: 'Experiment on plant growth under different light conditions.',
              lastModified: DateTime(2023, 10, 28, 9, 0)),
          _Note(
              title: 'Quiz 2',
              content: 'Prepare for biology quiz on cell structures.',
              lastModified: DateTime(2023, 10, 27, 13, 0)),
          _Note(
              title: 'Field Trip Details',
              content: 'Meet at botanical garden entrance at 9 AM next Friday.',
              lastModified: DateTime(2023, 10, 25, 10, 0)),
        ],
      ),
      _Folder(
        'NS 102',
        color: const Color(0xFFFF9800),
        notes: <_Note>[
          _Note(
              title: 'Health Assignment',
              content: 'Research on balanced nutrition and healthy eating habits.',
              lastModified: DateTime(2023, 10, 29, 8, 0)),
          _Note(
              title: 'Presentation Topic',
              content: 'Choose a topic related to mental well-being for presentation.',
              lastModified: DateTime(2023, 10, 28, 11, 0)),
        ],
      ),
      _Folder(
        'MATH 201',
        color: const Color(0xFFF44336),
        notes: <_Note>[
          _Note(
              title: 'Homework 5',
              content: 'Calculus problems from textbook, pages 120-125.',
              lastModified: DateTime(2023, 10, 30, 10, 0)),
          _Note(
              title: 'Exam Review',
              content: 'Linear algebra concepts, matrices, and vectors.',
              lastModified: DateTime(2023, 10, 28, 15, 0)),
          _Note(
              title: 'Problem Set 3',
              content: 'Differential equations practice.',
              lastModified: DateTime(2023, 10, 27, 17, 0)),
        ],
      ),
    ];
  }

  // Updates the _allNotes list by collecting all notes from _allFolders and sorting them
  void _updateAllNotesList() {
    setState(() {
      _allNotes = _allFolders.expand<_Note>((_Folder folder) => folder.notes).toList();
      _allNotes.sort((_Note a, _Note b) => b.lastModified.compareTo(a.lastModified));
    });
  }

  // Filters the _allFolders list based on the search query
  void _filterFolders() {
    final String query = _search.text.trim().toLowerCase();
    setState(() {
      _filteredFolders = _allFolders
          .where((_Folder f) => query.isEmpty || f.title.toLowerCase().contains(query))
          .toList();
    });
  }

  // Adds a new folder to the _allFolders list and re-filters
  void _createNewFolder(String folderName) {
    if (folderName.trim().isEmpty) return; // Prevent creating empty-named folders
    setState(() {
      _allFolders.add(_Folder(
        folderName,
        color: Theme.of(context).colorScheme.primary, // Default color for new folders
        notes: <_Note>[],
      ));
      _filterFolders(); // Update the displayed list to include the new folder
      _updateAllNotesList(); // Update the combined all notes list
    });
  }

  void _addNoteToFolder(String folderTitle, _Note newNote) {
    setState(() {
      final int folderIndex = _allFolders.indexWhere((_Folder f) => f.title == folderTitle);
      if (folderIndex != -1) {
        final _Folder folder = _allFolders[folderIndex];
        final List<_Note> updatedNotes = List<_Note>.from(folder.notes)..add(newNote);
        _allFolders[folderIndex] = _Folder(
          folder.title,
          locked: folder.locked,
          color: folder.color,
          notes: updatedNotes,
        );
        _filterFolders(); // Re-filter folders to reflect any changes if search is active
        _updateAllNotesList(); // Update the combined all notes list
      }
    });
  }

  void _updateExistingNoteInFolder(String folderTitle, _Note oldNote, _Note updatedNote) {
    setState(() {
      final int folderIndex = _allFolders.indexWhere((_Folder f) => f.title == folderTitle);
      if (folderIndex != -1) {
        final _Folder folder = _allFolders[folderIndex];
        final int noteIndex = folder.notes.indexWhere((_Note n) => n.id == oldNote.id);
        if (noteIndex != -1) {
          final List<_Note> updatedNotes = List<_Note>.from(folder.notes);
          updatedNotes[noteIndex] = updatedNote;
          _allFolders[folderIndex] = _Folder(
            folder.title,
            locked: folder.locked,
            color: folder.color,
            notes: updatedNotes,
          );
          _filterFolders(); // Re-filter folders to reflect any changes if search is active
          _updateAllNotesList(); // Update the combined all notes list
        }
      }
    });
  }

  void _deleteNoteFromFolder(String folderTitle, _Note noteToDelete) {
    setState(() {
      final int folderIndex = _allFolders.indexWhere((_Folder f) => f.title == folderTitle);
      if (folderIndex != -1) {
        final _Folder folder = _allFolders[folderIndex];
        final List<_Note> updatedNotes = List<_Note>.from(folder.notes);
        updatedNotes.removeWhere((_Note n) => n.id == noteToDelete.id);
        _allFolders[folderIndex] = _Folder(
          folder.title,
          locked: folder.locked,
          color: folder.color,
          notes: updatedNotes,
        );
        _filterFolders(); // Re-filter folders to reflect any changes if search is active
        _updateAllNotesList(); // Update the combined all notes list
      }
    });
  }

  // Helper to find the parent folder title of a given note
  String? _findNoteParentFolderTitle(_Note note) {
    for (final _Folder folder in _allFolders) {
      if (folder.notes.any((_Note n) => n.id == note.id)) {
        return folder.title;
      }
    }
    return null;
  }

  // Callback for notes managed from the "All Notes" view for updates
  void _handleUpdateNoteFromAllNotes(_Note updatedNote) {
    final String? folderTitle = _findNoteParentFolderTitle(updatedNote);
    if (folderTitle != null) {
      final _Note? oldNote =
          _allFolders.expand((_Folder f) => f.notes).firstWhereOrNull((_Note n) => n.id == updatedNote.id);
      if (oldNote != null) {
        _updateExistingNoteInFolder(folderTitle, oldNote, updatedNote);
      }
    }
  }

  // Callback for notes managed from the "All Notes" view for deletion
  void _handleDeleteNoteFromAllNotes(_Note noteToDelete) {
    final String? folderTitle = _findNoteParentFolderTitle(noteToDelete);
    if (folderTitle != null) {
      _deleteNoteFromFolder(folderTitle, noteToDelete);
    }
  }

  @override
  void dispose() {
    _search.removeListener(_filterFolders); // Remove listener to prevent memory leaks
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Top app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: <Widget>[
                  _RoundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'My Notes',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _RoundIconButton(
                    icon: Icons.more_vert_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Search input field (for both folders and all notes)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 48,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                        borderRadius:
                            const BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                      child: const Icon(Icons.search_rounded),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _search,
                        decoration: InputDecoration(
                          hintText: 'Search…',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.horizontal(right: Radius.circular(12)),
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.horizontal(right: Radius.circular(12)),
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.horizontal(right: Radius.circular(12)),
                            borderSide: BorderSide(color: cs.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Toggle: All Notes / Folders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: <Widget>[
                    _SegItem(
                      label: 'All Notes',
                      selected: _toggle == 'All Notes',
                      onTap: () => setState(() {
                        _toggle = 'All Notes';
                        _search.clear(); // Clear search when switching view
                        _updateAllNotesList(); // Ensure all notes are up-to-date
                      }),
                    ),
                    _SegItem(
                      label: 'Folders',
                      selected: _toggle == 'Folders',
                      onTap: () => setState(() {
                        _toggle = 'Folders';
                        _search.clear(); // Clear search when switching view
                        _filterFolders(); // Ensure folders are up-to-date
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // Main content area based on toggle
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _toggle == 'Folders'
                    ? _FoldersGrid(
                        folders: _filteredFolders, // Use the filtered list
                        onCreateNewFolder: _createNewFolder, // Pass the callback
                        onNoteAdded: _addNoteToFolder,
                        onNoteUpdated: _updateExistingNoteInFolder,
                        onNoteDeleted: _deleteNoteFromFolder,
                        key: const ValueKey('FoldersGrid'),
                      )
                    : _AllNotesView(
                        allNotes: _allNotes,
                        allFolders: _allFolders, // For folder selection when adding new note
                        onCreateNewFolder: _createNewFolder, // For creating new folder from all notes view
                        onNoteAdded: _addNoteToFolder, // For adding a new note after folder selection
                        onNoteUpdated: _handleUpdateNoteFromAllNotes, // For updating existing note
                        onNoteDeleted: _handleDeleteNoteFromAllNotes, // For deleting existing note
                        searchController: _search, // Pass search controller to filter all notes
                        key: const ValueKey('AllNotesView'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
    );
  }
}

class _SegItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? cs.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white10
                      : Colors.black12)
                  : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? cs.primary
                  : (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF92A4C9)
                      : Colors.grey[700]),
            ),
          ),
        ),
      ),
    );
  }
}

class _FoldersGrid extends StatelessWidget {
  final List<_Folder> folders;
  final ValueChanged<String> onCreateNewFolder; // Callback to create a new folder
  final void Function(String folderTitle, _Note newNote) onNoteAdded;
  final void Function(String folderTitle, _Note oldNote, _Note updatedNote) onNoteUpdated;
  final void Function(String folderTitle, _Note noteToDelete) onNoteDeleted;

  const _FoldersGrid({
    required this.folders,
    required this.onCreateNewFolder,
    required this.onNoteAdded,
    required this.onNoteUpdated,
    required this.onNoteDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final int cols = (c.maxWidth / 158).floor().clamp(1, 6);
        final List<Widget> items = <Widget>[
          ...folders.map<Widget>((_Folder f) => _FolderCard(
                folder: f,
                onNoteAdded: onNoteAdded,
                onNoteUpdated: onNoteUpdated,
                onNoteDeleted: onNoteDeleted,
                key: ValueKey<String>(f.title), // Provide a key for each folder card
              )),
          _NewFolderCard(
            onCreateNewFolder: onCreateNewFolder,
            key: const ValueKey<String>('NewFolderCard'), // Provide a key for the new folder card
          ), // en sona "New Folder"
        ];

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 4 / 5, // Kart üstü (4/3) + yazılar
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext _, int i) => items[i],
        );
      },
    );
  }
}

class _FolderCard extends StatelessWidget {
  final _Folder folder;
  final void Function(String folderTitle, _Note newNote) onNoteAdded;
  final void Function(String folderTitle, _Note oldNote, _Note updatedNote) onNoteUpdated;
  final void Function(String folderTitle, _Note noteToDelete) onNoteDeleted;

  const _FolderCard({
    required this.folder,
    required this.onNoteAdded,
    required this.onNoteUpdated,
    required this.onNoteDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => FolderDetailPage(
              folder: folder,
              onNoteAdded: onNoteAdded,
              onNoteUpdated: onNoteUpdated,
              onNoteDeleted: onNoteDeleted,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Üst görsel alanı
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Icon(Icons.folder, size: 64, color: folder.color),
                  ),
                  if (folder.locked)
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: folder.color.withAlpha(51),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Icon(Icons.lock, size: 16, color: folder.color),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              folder.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              '${folder.count} Notes',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF92A4C9)
                        : Colors.grey[600],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewFolderCard extends StatelessWidget {
  final ValueChanged<String> onCreateNewFolder; // Callback for creating a new folder

  const _NewFolderCard({required this.onCreateNewFolder, super.key});

  // Function to show the create folder dialog
  void _showCreateFolderDialog(BuildContext context) {
    final TextEditingController folderNameController = TextEditingController();
    showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Create New Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: const InputDecoration(hintText: 'Enter folder name'),
            autofocus: true, // Automatically focus the text field
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // Cancel button
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String folderName = folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  onCreateNewFolder(folderName); // Call the callback
                }
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        _showCreateFolderDialog(context); // Call the dialog when tapped
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.add, size: 48, color: cs.primary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'New Folder',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllNotesView extends StatefulWidget {
  final List<_Note> allNotes;
  final List<_Folder> allFolders; // For folder selection when adding new note
  final ValueChanged<String> onCreateNewFolder; // For creating new folder from all notes view
  final void Function(String folderTitle, _Note newNote) onNoteAdded;
  final void Function(_Note updatedNote) onNoteUpdated;
  final void Function(_Note noteToDelete) onNoteDeleted;
  final TextEditingController searchController;

  const _AllNotesView({
    required this.allNotes,
    required this.allFolders,
    required this.onCreateNewFolder,
    required this.onNoteAdded,
    required this.onNoteUpdated,
    required this.onNoteDeleted,
    required this.searchController,
    super.key,
  });

  @override
  State<_AllNotesView> createState() => _AllNotesViewState();
}

class _AllNotesViewState extends State<_AllNotesView> {
  List<_Note> _displayNotes = <_Note>[];

  @override
  void initState() {
    super.initState();
    _filterNotes(); // Initial filtering
    widget.searchController.addListener(_filterNotes);
  }

  @override
  void didUpdateWidget(covariant _AllNotesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the underlying allNotes list changes, re-filter/update our display list.
    if (widget.allNotes != oldWidget.allNotes ||
        widget.searchController.text != oldWidget.searchController.text) {
      _filterNotes();
    }
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_filterNotes);
    super.dispose();
  }

  void _filterNotes() {
    final String query = widget.searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayNotes = List<_Note>.from(widget.allNotes);
      } else {
        _displayNotes = widget.allNotes
            .where((_Note note) =>
                note.title.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _showFolderSelectionDialog(BuildContext context) {
    String? selectedFolderTitle;
    final TextEditingController newFolderNameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Folder for New Note'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    initialValue: selectedFolderTitle,
                    decoration: const InputDecoration(
                      labelText: 'Existing Folders',
                      border: OutlineInputBorder(),
                    ),
                    items: widget.allFolders.map<DropdownMenuItem<String>>((_Folder folder) {
                      return DropdownMenuItem<String>(
                        value: folder.title,
                        child: Text(folder.title),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFolderTitle = newValue;
                      });
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: newFolderNameController,
                          decoration: const InputDecoration(
                            hintText: 'Or enter new folder name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_box_rounded),
                        onPressed: () {
                          final String newFolderName = newFolderNameController.text.trim();
                          if (newFolderName.isNotEmpty &&
                              !widget.allFolders.any((_Folder f) => f.title == newFolderName)) {
                            widget.onCreateNewFolder(newFolderName);
                            setState(() {
                              selectedFolderTitle = newFolderName;
                              newFolderNameController.clear();
                            });
                            // Re-build the dialog content to refresh the dropdown, or just trust the next dialog build.
                            // For simplicity, we just set the selected title and let the next action handle it.
                            // Note: onCreateNewFolder will rebuild MyNotesPage, so this dialog might close.
                            // A better approach would be to update the folder list locally, then call onCreateNewFolder on dialog close.
                            // For this project, we'll assume the user will pick from updated list on next open if they need it.
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext); // Close folder selection dialog
                    if (selectedFolderTitle != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => AddEditNotePage(
                            folderTitle: selectedFolderTitle!,
                            onSave: (newNote) => widget.onNoteAdded(selectedFolderTitle!, newNote),
                          ),
                        ),
                      );
                    } else {
                      // Optionally show a snackbar or alert if no folder is selected/created
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select or create a folder.')),
                      );
                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_displayNotes.length} Notes',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF92A4C9) : Colors.grey[700]),
              ),
            ),
          ),
          Expanded(
            child: _displayNotes.isEmpty
                ? Center(
                    child: Text(
                      'No notes found.',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: cs.primary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _displayNotes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _NoteCard(
                        note: _displayNotes[index],
                        onNoteTap: (tappedNote) {
                          // Find the folder title for the tapped note
                          final String? folderTitle = widget.allFolders
                              .firstWhereOrNull((_Folder f) =>
                                  f.notes.any((_Note n) => n.id == tappedNote.id))
                              ?.title;

                          if (folderTitle != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => AddEditNotePage(
                                  folderTitle: folderTitle,
                                  noteToEdit: tappedNote,
                                  onSave: widget.onNoteUpdated,
                                  onDelete: widget.onNoteDeleted,
                                ),
                              ),
                            );
                          } else {
                            // Should not happen if data is consistent
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not find parent folder for note.')),
                            );
                          }
                        },
                        key: ValueKey<String>(_displayNotes[index].id), // Provide a key for each note card
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFolderSelectionDialog(context); // Show dialog to select folder first
        },
        backgroundColor: cs.primary,
        child: Icon(Icons.add_rounded, color: cs.onPrimary),
      ),
    );
  }
}

class _Note {
  final String id; // Unique identifier for each note
  final String title;
  final String content;
  final DateTime lastModified;

  _Note({
    String? id, // Optional for new notes, will be generated
    required this.title,
    required this.content,
    required this.lastModified,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(); // Simple unique ID generation

  // Implement equality based on ID
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Note && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  _Note copyWith({
    String? title,
    String? content,
    DateTime? lastModified,
  }) {
    return _Note(
      id: id, // Keep the same ID
      title: title ?? this.title,
      content: content ?? this.content,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}

class _Folder {
  final String title;
  final bool locked;
  final Color color;
  final List<_Note> notes;

  int get count => notes.length;

  _Folder(this.title, {this.locked = false, required this.color, required this.notes});
}

class FolderDetailPage extends StatefulWidget {
  final _Folder folder;
  final void Function(String folderTitle, _Note newNote) onNoteAdded;
  final void Function(String folderTitle, _Note oldNote, _Note updatedNote) onNoteUpdated;
  final void Function(String folderTitle, _Note noteToDelete) onNoteDeleted;

  const FolderDetailPage({
    required this.folder,
    required this.onNoteAdded,
    required this.onNoteUpdated,
    required this.onNoteDeleted,
    super.key,
  });

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  List<_Note> _displayNotes = <_Note>[]; // Notes to display after filtering

  @override
  void initState() {
    super.initState();
    _displayNotes = List<_Note>.from(widget.folder.notes); // Initialize with current folder notes
    _searchController.addListener(_filterNotes);
  }

  @override
  void didUpdateWidget(covariant FolderDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the underlying folder's notes change (e.g., a note was added/edited/deleted in parent),
    // re-filter/update our display list.
    if (widget.folder.notes != oldWidget.folder.notes) {
      _filterNotes();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterNotes);
    _searchController.dispose();
    super.dispose();
  }

  void _filterNotes() {
    final String query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayNotes = List<_Note>.from(widget.folder.notes); // Work with a copy of original notes
      } else {
        _displayNotes = widget.folder.notes
            .where((_Note note) =>
                note.title.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  // Helper methods to interact with parent callbacks
  void _handleAddNewNote(_Note newNote) {
    widget.onNoteAdded(widget.folder.title, newNote);
    _filterNotes(); // Re-filter to show the new note
  }

  void _handleUpdateNote(_Note updatedNote) {
    final _Note? oldNote =
        widget.folder.notes.firstWhereOrNull((_Note n) => n.id == updatedNote.id);
    if (oldNote != null) {
      widget.onNoteUpdated(widget.folder.title, oldNote, updatedNote);
    }
    _filterNotes(); // Re-filter to show updated note
  }

  void _handleDeleteNote(_Note noteToDelete) {
    widget.onNoteDeleted(widget.folder.title, noteToDelete);
    _filterNotes(); // Re-filter to remove the deleted note
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Top app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: <Widget>[
                  _RoundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(), // Back button
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.folder.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _RoundIconButton(
                    icon: Icons.more_vert_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 48,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                        borderRadius:
                            const BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                      child: const Icon(Icons.search_rounded),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search notes...',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.horizontal(right: Radius.circular(12)),
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.horizontal(right: Radius.circular(12)),
                            borderSide: BorderSide(
                              color: isDark ? const Color(0xFF232F48) : const Color(0xFFD6D3D1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.horizontal(right: Radius.circular(12)),
                            borderSide: BorderSide(color: cs.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Note count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_displayNotes.length} Notes',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF92A4C9) : Colors.grey[700]),
                ),
              ),
            ),
            Expanded(
              child: _displayNotes.isEmpty
                  ? Center(
                      child: Text(
                        'No notes found.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: cs.primary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _displayNotes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _NoteCard(
                          note: _displayNotes[index],
                          onNoteTap: (tappedNote) {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => AddEditNotePage(
                                  folderTitle: widget.folder.title,
                                  noteToEdit: tappedNote,
                                  onSave: _handleUpdateNote,
                                  onDelete: _handleDeleteNote,
                                ),
                              ),
                            );
                          },
                          key: ValueKey<String>(_displayNotes[index].id), // Provide a key for each note card
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open AddEditNotePage for adding a new note
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => AddEditNotePage(
                folderTitle: widget.folder.title,
                onSave: _handleAddNewNote,
              ),
            ),
          );
        },
        backgroundColor: cs.primary,
        child: Icon(Icons.add_rounded, color: cs.onPrimary),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final _Note note;
  final ValueChanged<_Note> onNoteTap; // New callback

  const _NoteCard({required this.note, required this.onNoteTap, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final DateFormat dateFormat = DateFormat('MMM d, yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? const Color(0xFF232F48) : Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          onNoteTap(note); // Call the new callback
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                note.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                note.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? const Color(0xFF92A4C9) : Colors.grey[700]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  dateFormat.format(note.lastModified),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? const Color(0xFF92A4C9) : Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New Widget: AddEditNotePage for creating/editing a single note
class AddEditNotePage extends StatefulWidget {
  final _Note? noteToEdit; // Optional, if editing an existing note
  final String folderTitle; // Title of the folder this note belongs to
  final Function(_Note note) onSave; // Callback to save the note (new or updated)
  final Function(_Note note)? onDelete; // Optional callback for deletion

  const AddEditNotePage({
    super.key,
    this.noteToEdit,
    required this.folderTitle,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteToEdit?.title ?? '');
    _contentController = TextEditingController(text: widget.noteToEdit?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Top app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: <Widget>[
                  _RoundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(), // Back button
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.noteToEdit == null ? 'New Note' : 'Edit Note',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.noteToEdit != null)
                    _RoundIconButton(
                      icon: Icons.delete_rounded,
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Delete Note'),
                            content: Text(
                                'Are you sure you want to delete "${widget.noteToEdit!.title}"?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  if (widget.onDelete != null && widget.noteToEdit != null) {
                                    widget.onDelete!(widget.noteToEdit!);
                                  }
                                  Navigator.of(context).pop(); // Go back to FolderDetailPage or AllNotesView
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    _RoundIconButton(
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white54 : Colors.grey[600],
                            ),
                      ),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                      maxLines: null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Folder: ${widget.folderTitle}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? const Color(0xFF92A4C9) : Colors.grey[500]),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        hintText: 'Start typing your note here...',
                        border: InputBorder.none,
                        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isDark ? Colors.white54 : Colors.grey[600],
                            ),
                      ),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String title = _titleController.text.trim();
          final String content = _contentController.text.trim();

          if (title.isNotEmpty || content.isNotEmpty) {
            final _Note resultNote = (widget.noteToEdit == null)
                ? _Note(
                    title: title.isEmpty ? 'Untitled Note' : title,
                    content: content,
                    lastModified: DateTime.now(),
                  )
                : widget.noteToEdit!.copyWith(
                    title: title.isEmpty ? 'Untitled Note' : title,
                    content: content,
                    lastModified: DateTime.now(),
                  );
            widget.onSave(resultNote);
          }
          Navigator.of(context).pop();
        },
        backgroundColor: cs.primary,
        child: Icon(Icons.save_rounded, color: cs.onPrimary),
      ),
    );
  }
}

// Add extension for Iterable to use firstWhereOrNull
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final T element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
    // Alternative for Dart 2.12+ with null safety and collection if/for:
    // return cast<T?>().firstWhere((element) => test(element!), orElse: () => null);
  }
}
