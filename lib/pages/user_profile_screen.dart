import 'package:flutter/material.dart';

/// Aynı tema renkleri (Academic Calendar ekranıyla uyumlu)
const Color kPrimary = Color(0xFF135BEC);
const Color kBackgroundLight = Color(0xFFF6F6F8);
const Color kBackgroundDark = Color(0xFF101622);

class SavedNotesScreen extends StatefulWidget {
  static const String routeName = "Saved_Notes_Screen";

  const SavedNotesScreen({Key? key}) : super(key: key);

  @override
  State<SavedNotesScreen> createState() => _SavedNotesScreenState();
}

class _SavedNotesScreenState extends State<SavedNotesScreen> {
  bool _isUploadedTab = true; // true: My Uploaded Notes, false: Saved Notes

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? kBackgroundDark : kBackgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(isDark),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileHeader(isDark),
                  _buildSegmentedTabs(isDark),
                  _isUploadedTab
                      ? _buildUploadedNotesList(isDark)
                      : _buildSavedNotesEmptyState(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────── TOP APP BAR ────────────────

  Widget _buildTopBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          .copyWith(bottom: 4),
      color: isDark ? kBackgroundDark : kBackgroundLight,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              icon: Icon(
                Icons.arrow_back,
                size: 24,
                color: isDark ? Colors.grey.shade300 : const Color(0xFF4A4A4A),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                  color: isDark ? Colors.white : const Color(0xFF4A4A4A),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              onPressed: () {
                // settings action
              },
              icon: Icon(
                Icons.settings,
                size: 24,
                color: isDark ? Colors.white : const Color(0xFF4A4A4A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────── PROFILE HEADER ────────────────

  Widget _buildProfileHeader(bool isDark) {
    return Container(
      color: isDark ? kBackgroundDark : kBackgroundLight,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuCOkKjr4HxjTn7Y5P6sqH_gqOF12uJpUe7tveeMBWSThTeMVI2Ei4jTH9hazKvv0cjaBEpOILoKc1oKWssEPMgEb4kmBX6kt2k-3mYF-IVzTgLzbcf9Tl1i3d-G17fQJKk9zXxKGpZK52utZEsDG1pDJT5XaVjW_W3RCc11DPEZd-l2F1punbC93V8mjyE_mj_NcxRMfAFwtZnqrSeIDKjOkOCJwQ_8oy_PzvStYyc0SCFF4-i4PnXTGKtjNYM0z7Q_INUjJHn--t40",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ayşe Yılmaz',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: isDark ? Colors.white : const Color(0xFF4A4A4A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Computer Science, 2025',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                // Edit profile action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────── SEGMENTED TABS ────────────────

  Widget _buildSegmentedTabs(bool isDark) {
    final bgContainer =
        isDark ? Colors.grey.shade900 : Colors.grey.shade300.withOpacity(0.6);
    final inactiveText =
        isDark ? Colors.grey.shade300 : const Color(0xFF4A4A4A);

    Widget buildTab(String label, bool selected) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isUploadedTab = (label == 'My Uploaded Notes');
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 36,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: selected ? kPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : inactiveText,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: isDark ? kBackgroundDark : kBackgroundLight,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bgContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            buildTab('My Uploaded Notes', _isUploadedTab),
            buildTab('Saved Notes', !_isUploadedTab),
          ],
        ),
      ),
    );
  }

  // ──────────────── UPLOADED NOTES LİSTESİ ────────────────

  Widget _buildUploadedNotesList(bool isDark) {
    final dividerColor =
        isDark ? const Color(0xFF262A35) : Colors.grey.shade300;

    return Container(
      color: isDark ? kBackgroundDark : kBackgroundLight,
      child: Column(
        children: [
          _buildNoteListItem(
            isDark: isDark,
            icon: Icons.picture_as_pdf,
            title: 'CS 301 - Lecture 5 Notes',
            subtitle: 'Uploaded: 15 Oct 2023',
            dividerColor: dividerColor,
          ),
          _buildNoteListItem(
            isDark: isDark,
            icon: Icons.description,
            title: 'PSY 101 - Midterm Study Guide',
            subtitle: 'Uploaded: 03 Oct 2023',
            dividerColor: dividerColor,
          ),
          _buildNoteListItem(
            isDark: isDark,
            icon: Icons.picture_as_pdf,
            title: 'MATH 201 - Linear Algebra Concepts',
            subtitle: 'Uploaded: 28 Sep 2023',
            dividerColor: dividerColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteListItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color dividerColor,
  }) {
    final textMainColor =
        isDark ? Colors.white : const Color(0xFF4A4A4A); // neutral-gray
    final textSubColor =
        isDark ? Colors.grey.shade400 : Colors.grey.shade500;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: dividerColor),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textMainColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: textSubColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // more actions
            },
            icon: Icon(
              Icons.more_vert,
              size: 24,
              color: isDark ? Colors.grey.shade400 : const Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────── SAVED NOTES EMPTY STATE ────────────────

  Widget _buildSavedNotesEmptyState(bool isDark) {
    return Container(
      color: isDark ? kBackgroundDark : kBackgroundLight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload,
            size: 64,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Notes Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "You haven't uploaded any notes yet. Tap the '+' button to share your first note!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
