import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recentActivities = [
      'Content flagged for review – User @jane_doe reported a note.',
      'New user signed up – @john_smith has joined.',
      'Content approved – Admin @mark reviewed and approved a note.',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF050816),
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.switch_account, color: Colors.white, size: 18),
            label: const Text('Switch to User', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome, Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(title: 'Total Users', value: '12,456', icon: Icons.people),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(title: 'Active Users', value: '1,203', icon: Icons.check_circle),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Manage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ManageCard(
                      label: 'Users',
                      icon: Icons.person_outline,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ManageCard(
                      label: 'Courses',
                      icon: Icons.menu_book_outlined,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ManageCard(
                      label: 'Instructors',
                      icon: Icons.school_outlined,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ManageCard(
                      label: 'Flagged Content',
                      icon: Icons.flag_outlined,
                      highlightColor: const Color(0xFFB45309),
                      onTap: () {
                        Navigator.pushNamed(context, '/flagged');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: recentActivities.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1D4ED8).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.notifications, size: 20, color: Color(0xFF60A5FA)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              recentActivities[index],
                              style: const TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D283A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ManageCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? highlightColor;

  const _ManageCard({required this.label, required this.icon, required this.onTap, this.highlightColor});

  @override
  Widget build(BuildContext context) {
    final baseColor = highlightColor ?? const Color(0xFF0F172A);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF1E293B)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: Colors.white),
            ),
            const Spacer(),
            Text('Manage $label', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
