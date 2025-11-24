import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suders/lib/utils/app_colors.dart';
import 'package:suders/lib/utils/app_text_styles.dart';
import 'package:suders/lib/utils/app_paddings.dart';

class FlaggedItem {
  final String courseName;
  final String summary;
  final String reason;

  FlaggedItem({
    required this.courseName,
    required this.summary,
    required this.reason,
  });
}

class FlaggedContentScreen extends StatefulWidget {
  const FlaggedContentScreen({super.key});

  @override
  State<FlaggedContentScreen> createState() => _FlaggedContentScreenState();
}

class _FlaggedContentScreenState extends State<FlaggedContentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  List<FlaggedItem> _items = [
    FlaggedItem(
      courseName: 'CS204 – Data Structures',
      summary: 'Note about linked lists was reported as potentially incorrect or misleading.',
      reason: 'Incorrect Information',
    ),
    FlaggedItem(
      courseName: 'NS209 – Astronomy',
      summary: 'Review contains inappropriate language.',
      reason: 'Inappropriate Language',
    ),
    FlaggedItem(
      courseName: 'MATH201 – Calculus',
      summary: 'Uploaded cheat sheet suspected to violate academic honesty policy.',
      reason: 'Academic Dishonesty',
    ),
  ];

  List<FlaggedItem> get filteredItems {
    if (_searchText.isEmpty) return _items;
    final q = _searchText.toLowerCase();
    return _items.where((item) {
      return item.courseName.toLowerCase().contains(q) ||
          item.summary.toLowerCase().contains(q) ||
          item.reason.toLowerCase().contains(q);
    }).toList();
  }

  void _approve(FlaggedItem item) {
    setState(() => _items.remove(item));
  }

  void _remove(FlaggedItem item) {
    setState(() => _items.remove(item));
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Flagged Content', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textMain),
              decoration: InputDecoration(
                hintText: 'Search content',
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.card,
                prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                suffixIcon: _searchText.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchText = '');
                  },
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.borderSoft),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.borderSoft),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => _searchText = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                child: Text('No flagged content.', style: TextStyle(color: AppColors.textSecondary)),
              )
                  : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: AppPaddings.card,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.courseName,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                        const SizedBox(height: 6),
                        Text(item.summary, style: AppTextStyles.body, maxLines: 3, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.flag, size: 16, color: AppColors.danger),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text('Reason: ${item.reason}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.danger)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _approve(item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _remove(item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.danger,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
