import 'package:flutter/material.dart';
import 'package:suders/utils/app_colors.dart';
import 'package:suders/utils/app_text_styles.dart';
import 'package:suders/utils/app_paddings.dart';

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
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Admin Dashboard', style: AppTextStyles.title),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: Icon(Icons.switch_account, color: AppColors.textMain, size: 18),
            label: Text('Switch to User', style: TextStyle(color: AppColors.textMain)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome, Admin', style: AppTextStyles.title),
              AppPaddings.betweenItems,
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Total Users',
                      value: '12,456',
                      icon: Icons.people,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Active Users',
                      value: '1,203',
                      icon: Icons.check_circle,
                    ),
                  ),
                ],
              ),
              AppPaddings.betweenSections,
              Text('Manage', style: AppTextStyles.sectionTitle),
              AppPaddings.betweenItems,
              Row(
                children: [
                  Expanded(
                    child: _ManageCard(
                      label: 'Users',
                      icon: Icons.person_outline,
                      onTap: () => Navigator.pushNamed(context, '/admin/users'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ManageCard(
                      label: 'Courses',
                      icon: Icons.menu_book_outlined,
                      onTap: () => Navigator.pushNamed(context, '/admin/courses'),
                    ),
                  ),
                ],
              ),
              AppPaddings.betweenItems,
              Row(
                children: [
                  Expanded(
                    child: _ManageCard(
                      label: 'Instructors',
                      icon: Icons.school_outlined,
                      onTap: () => Navigator.pushNamed(context, '/admin/instructors'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ManageCard(
                      label: 'Flagged Content',
                      icon: Icons.flag_outlined,
                      highlightColor: AppColors.warning,
                      onTap: () => Navigator.pushNamed(context, '/flagged'),
                    ),
                  ),
                ],
              ),
              AppPaddings.betweenSections,
              Text('Recent Activity', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: recentActivities.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: AppPaddings.card,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.cardAlt,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.notifications, size: 20, color: AppColors.primary),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(recentActivities[index], style: AppTextStyles.body),
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
      padding: AppPaddings.card,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.cardAlt,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.textMain),
              ),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.small),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
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
    final Color baseColor = highlightColor ?? AppColors.card;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 90,
        padding: AppPaddings.card,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
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
              child: Icon(icon, size: 18, color: AppColors.textMain),
            ),
            const Spacer(),
            Text('Manage $label', style: AppTextStyles.small),
          ],
        ),
      ),
    );
  }
}
