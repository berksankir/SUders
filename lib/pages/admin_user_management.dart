import 'package:flutter/material.dart';
import 'package:suders/pages/admin_dashboard_page.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  UserFilter _selectedFilter = UserFilter.all;

  final List<User> _users = [
    User(
      name: 'Taylan Torun',
      email: 'taylan.torun@sabanciuniv.edu',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCAKZQDEsiN6HRGwpsiT0om1YpdNttvF8b-Qq1X83SWJqcSO34kxbcxQQR3XGpxtUBJIibGN3-B6xwRzKLnpfjRNOyWv_FsTpFl87sXoGile0n0A-U8-223JVtxSPvlPuD6Zew_3f7HybqRLkx6OB8OO511IG7G-ma2vkuAZ-x9QYITCUDRJwW4nYI3-OTDGbPyyqHDrgHOE7b-vcUBx_MPiSnx4yTMIMmyKgT3ByjZn979o3Y9PjBdL6HRRM3rDHgl3I3wTVApBQNp',
      status: UserStatus.pending,
    ),
    User(
      name: 'Ayça Sudem Aydoğdu',
      email: 'ayca.aydogdu@sabanciuniv.edu',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD62noDwLRUiY78eVV_M0tSNWEBVsiNTWobvUys4W6d7KmRrSzPdg0qaDIqktxx9vLI31fSk0nuuMsMx-A3SvDNwF8fYFS5d9GqAD1WjylyylUBz3_oDDz2Y0Kd2N7KCrVcWTBe9DkckaCRiY8_M8YGDAoH13p2hgcCaHAfLWAgpf1h2DVbCgNRfww9atoMwbt5SRjGrqaGsGF4nwrSFCdj3wdZ813waS6aPseX9_DMDSELHlXw181SNqRFJUa6W1UxCkKAZTUjvJ5A',
      status: UserStatus.verified,
    ),
    User(
      name: 'Efe SarıBay',
      email: 'efe.saribay@sabanciuniv.edu',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBJJ6fxGBlYRhf66G78cSbZiVde5P6QfhWx4SV1ePWO5M-OXpO_eTzIgbgdQjdBVe_GUnjEnhG-5s-VcPigAIJLMP0t1cE2JNM2bOYucb8bJD1xNvIf0vNB9yF0bxhKn0ChSiRdsvtaI8z9MIY-9peESTqZf3iJm8DgeJVQcpICeebcDiE0J953NFNbnjXUPmpZLE85sbWareUt1xG2kNcJGYULPVjKaD6IOsOy3rACwopvVOKz4FEbG_6eISFAAUwHDUqP3uLwjHQ2',
      status: UserStatus.verified,
    ),
    User(
      name: 'Göktuğ Kırkıl',
      email: 'goktug.kirkil@sabanciuniv.edu',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCGAA7ZbzZJoeOQcBdpcE31P-LIs-a_O9Xe4E0eswWM8TRTWitNuwyJIDpbA_yenek9gMneWajt-JvtCpjFwvNW8_IY2nlZhADYDJ5u9D3nIJHlgmyGy7RhwrLBfeFF7jlgpvKYD3t0E46KIGafAUV5-2inDvT30eA2eiB3Qx-xN7WWp4_VDwaJS_inXV8UitBfFXDP8arRigluEnKEyfUJLDV_JmbT3i5Prahc_SJDua_hO0tO-aD1MO60Y_W3WT0LFdmB7sMzCsI7',
      status: UserStatus.suspended,
    ),
    User(
      name: 'Berk Sankır',
      email: 'berk.sankir@sabanciuniv.edu',
      imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBHji4uhWdag4UIPa2U8U14MRJb8eL9kxp3ommWCJlCyN6j1NtiXTo4xxirVAzR2qZUHK5wJ3MJ2roMaYIpDrjJLUB0uPNUURfxq3mlB9Pt3SHbGmCv96onO_sBDVA0_sNiFcFm5uVR6jTiBNMJXp-g1GWq13UPhT2333ccS0SJoKxaoWlRiLllh7kREMKpojYWehzlpNpAYUnZizD_dJqicb7rZcWlcf_SYNVIEnhi0qTU3dx9hjK7j5QETXvXmWEHaLI07aTXNitX',
      status: UserStatus.pending,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<User> get _filteredUsers {
    final query = _searchController.text.toLowerCase().trim();

    return _users.where((u) {
      final matchesText = query.isEmpty ||
          u.name.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query);

      final matchesFilter = switch (_selectedFilter) {
        UserFilter.all => true,
        UserFilter.active => u.status == UserStatus.verified,
        UserFilter.suspended => u.status == UserStatus.suspended,
        UserFilter.pending => u.status == UserStatus.pending,
      };

      return matchesText && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color:
                isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: isDark ? Colors.white : Colors.grey.shade900,
                  ),
                  const Spacer(),
                  Text(
                    'User Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade900,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Icon(
                      Icons.search,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search by name or email...',
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),

            // Filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _selectedFilter == UserFilter.all,
                    onTap: () => setState(() {
                      _selectedFilter = UserFilter.all;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Active',
                    selected: _selectedFilter == UserFilter.active,
                    onTap: () => setState(() {
                      _selectedFilter = UserFilter.active;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Suspended',
                    selected: _selectedFilter == UserFilter.suspended,
                    onTap: () => setState(() {
                      _selectedFilter = UserFilter.suspended;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pending',
                    selected: _selectedFilter == UserFilter.pending,
                    onTap: () => setState(() {
                      _selectedFilter = UserFilter.pending;
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // User list
            Expanded(
              child: ListView.builder(
                padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return _UserListItem(
                    user: user,
                    onStatusChange: (newStatus) {
                      setState(() {
                        final idx = _users.indexOf(user);
                        _users[idx] = User(
                          name: user.name,
                          email: user.email,
                          imageUrl: user.imageUrl,
                          status: newStatus,
                        );
                      });
                    },
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

// MODELS & SMALL WIDGETS

enum UserStatus { verified, pending, suspended}

enum UserFilter { all, active, suspended, pending }

class User {
  final String name;
  final String email;
  final String imageUrl;
  final UserStatus status;

  User({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.status,
  });
}

class _UserListItem extends StatelessWidget {
  final User user;
  final void Function(UserStatus newStatus) onStatusChange;

  const _UserListItem({
    required this.user,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (statusText, bgColor, textColor) = switch (user.status) {
      UserStatus.verified => (
      'Verified',
      Colors.green.withOpacity(0.2),
      Colors.green.shade400,
      ),
      UserStatus.pending => (
      'Pending',
      Colors.orange.withOpacity(0.2),
      Colors.orange.shade400,
      ),
      UserStatus.suspended => (
      'Suspended',
      Colors.red.withOpacity(0.2),
      Colors.red.shade400,
      ),

    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                          isDark ? Colors.white : Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),

              IconButton(
                onPressed: () async {
                  final selected = await showMenu<UserStatus>(
                    context: context,
                    position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
                    items: [
                      const PopupMenuItem(
                        value: UserStatus.verified,
                        child: Text("Verified"),
                      ),
                      const PopupMenuItem(
                        value: UserStatus.pending,
                        child: Text("Pending"),
                      ),
                      const PopupMenuItem(
                        value: UserStatus.suspended,
                        child: Text("Suspended"),
                      ),
                    ],
                  );

                  if (selected != null) {
                    onStatusChange(selected);
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  size: 22,
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color selectedColor = const Color(0xFF135BEC);
    final Color unselectedBg =
    isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? selectedColor : unselectedBg,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected
                ? Colors.white
                : (isDark ? Colors.grey.shade200 : Colors.grey.shade800),
          ),
        ),
      ),
    );
  }
}
