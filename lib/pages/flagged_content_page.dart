import 'package:flutter/material.dart';

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
      summary: 'Review text contains inappropriate language according to multiple users.',
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
    setState(() {
      _items.remove(item);
    });
  }

  void _remove(FlaggedItem item) {
    setState(() {
      _items.remove(item);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Flagged Content',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search content',
                filled: true,
                fillColor: const Color(0xFF0F172A),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchText.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchText = '');
                  },
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1F2937)),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1F2937)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF2563EB)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => setState(() => _searchText = v),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                child: Text(
                  'No flagged content.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF1E293B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.courseName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.summary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.flag, size: 16, color: Color(0xFFEF4444)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Reason: ${item.reason}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFEF4444),
                                ),
                              ),
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
                                backgroundColor: const Color(0xFF16A34A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _remove(item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                foregroundColor: Colors.white,
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
