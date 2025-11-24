import 'package:flutter/material.dart';

class CourseNotesPage extends StatefulWidget {
  final String courseCode;
  final String courseName;

  const CourseNotesPage({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  State<CourseNotesPage> createState() => _CourseNotesPageState();
}

class _CourseNotesPageState extends State<CourseNotesPage> {
  String selectedYear = '2024-2025';
  String selectedTerm = 'Fall';

  final List<_Note> notes = [
    _Note(
      termLabel: '2025 Spring',
      title: 'Midterm 1 Review Sheet',
      uploader: 'Anonymous',
      upVotes: 12,
      downVotes: 1,
    ),
    _Note(
      termLabel: '2024 Fall',
      title: 'Finals Cheat Sheet',
      uploader: 'Jane Doe',
      upVotes: 8,
      downVotes: 0,
    ),
    _Note(
      termLabel: '2024 Fall',
      title: 'Lecture 5 Notes - Big O',
      uploader: 'John Appleseed',
      upVotes: 5,
      downVotes: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const backgroundDark = Color(0xFF101622);
    const cardColor = Color(0xFF182131);
    const primary = Color(0xFF135BEC);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          '${widget.courseCode} - ${widget.courseName}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _DropdownBox<String>(
                          value: selectedYear,
                          items: const ['2024-2025', '2023-2024', '2022-2023'],
                          labelBuilder: (v) => 'Year: $v',
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => selectedYear = v);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DropdownBox<String>(
                          value: selectedTerm,
                          items: const ['Fall', 'Spring', 'Summer'],
                          labelBuilder: (v) => 'Term: $v',
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => selectedTerm = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Course Notes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: [
                      for (final note in notes)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _NoteCard(
                            note: note,
                            cardColor: cardColor,
                            onDownload: () {},
                            onUpvote: () {
                              setState(() {
                                note.upVotes++;
                              });
                            },
                            onDownvote: () {
                              setState(() {
                                note.downVotes++;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ✅ NAMED ROUTE İLE UPLOAD'A GİDİYOR
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: backgroundDark.withOpacity(0.9),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/uploadNotes');
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text(
                      'Upload New Note',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- Model -----------------

class _Note {
  final String termLabel;
  final String title;
  final String uploader;
  int upVotes;
  int downVotes;

  _Note({
    required this.termLabel,
    required this.title,
    required this.uploader,
    required this.upVotes,
    required this.downVotes,
  });
}

// ----------------- Note Card -----------------

class _NoteCard extends StatelessWidget {
  final _Note note;
  final Color cardColor;
  final VoidCallback onDownload;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const _NoteCard({
    required this.note,
    required this.cardColor,
    required this.onDownload,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 8, offset: Offset(0, 4), color: Colors.black26),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.termLabel,
            style: const TextStyle(
              color: Color(0xFF135BEC),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            note.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Uploaded by ${note.uploader}',
            style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: onUpvote,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          note.upVotes.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: onDownvote,
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          note.downVotes.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2937),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onDownload,
                icon: const Icon(Icons.download, color: Colors.white, size: 18),
                label: const Text(
                  'Download',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------- Dropdown -----------------

class _DropdownBox<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const _DropdownBox({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const boxColor = Color(0xFF182131);

    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: boxColor,
          icon: const Icon(Icons.expand_more, color: Colors.grey),
          style: const TextStyle(color: Colors.white),
          items: items
              .map(
                (e) =>
                    DropdownMenuItem<T>(value: e, child: Text(labelBuilder(e))),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
