import 'package:flutter/material.dart';
import 'package:suders/utils/app_colors.dart';
import 'package:suders/utils/app_text_styles.dart';
import 'package:suders/utils/app_paddings.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileHeader(),
                  _buildSegmentedTabs(),
                  _isUploadedTab
                      ? _buildUploadedNotesList()
                      : _buildSavedNotesEmptyState(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────── TOP APP BAR ────────────────

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          .copyWith(bottom: 4),
      color: AppColors.background,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/courses');
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
                color: AppColors.textMain,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Profile',
                style: AppTextStyles.sectionTitle,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/admin/dashboard');
            },
            icon: const Icon(
              Icons.switch_account,
              size: 18,
              color: AppColors.textMain,
            ),
            label: Text(
              'Switch to Admin',
              style: AppTextStyles.small.copyWith(
                color: AppColors.textMain,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────── PROFILE HEADER ────────────────

  Widget _buildProfileHeader() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(
                  'assets/images/profile_picture.jpg',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ayşe Yılmaz',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Computer Science, 2025',
                      style: AppTextStyles.body,
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
                backgroundColor: AppColors.primary,
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

  Widget _buildSegmentedTabs() {
    final bgContainer = AppColors.cardAlt;
    final inactiveText = AppColors.textSecondary;

    Widget buildTab(String label, bool selected) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            if (label == 'Saved Notes') {
              // Navigate to Saved Notes screen
              Navigator.pushNamed(context, '/savedNotes');
            } else {
              setState(() {
                _isUploadedTab = (label == 'My Uploaded Notes');
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 36,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
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
      color: AppColors.background,
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

  Widget _buildUploadedNotesList() {
    final dividerColor = AppColors.border;

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _buildNoteListItem(
            icon: Icons.picture_as_pdf,
            title: 'CS 301 - Lecture 5 Notes',
            subtitle: 'Uploaded: 15 Oct 2023',
            dividerColor: dividerColor,
          ),
          _buildNoteListItem(
            icon: Icons.description,
            title: 'PSY 101 - Midterm Study Guide',
            subtitle: 'Uploaded: 03 Oct 2023',
            dividerColor: dividerColor,
          ),
          _buildNoteListItem(
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
    required IconData icon,
    required String title,
    required String subtitle,
    required Color dividerColor,
  }) {
    final textMainColor = AppColors.textMain;
    final textSubColor = AppColors.textSecondary;

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
              color: AppColors.primary,
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
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────── SAVED NOTES EMPTY STATE ────────────────

  Widget _buildSavedNotesEmptyState() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_upload,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Notes Yet',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 6),
          Text(
            "You haven't uploaded any notes yet. Tap the '+' button to share your first note!",
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
