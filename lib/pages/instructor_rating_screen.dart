import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstructorRatingsApp extends StatelessWidget {
  const InstructorRatingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color seed = const Color(0xFF3A7BFA);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instructor Ratings',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        brightness: Brightness.dark,
      ),
      home: const InstructorRatingsPage(),
    );
  }
}

/// A private class to hold the dynamically updated global total rating sum and total review count for an instructor.
class _InstructorDynamicData {
  double totalRatingSum; // Represents the sum of all rating points
  int reviews; // Represents the total number of reviews

  _InstructorDynamicData({required this.totalRatingSum, required this.reviews});
}

class InstructorRatingsData extends ChangeNotifier {
  String _campus = 'All Campuses';
  String _sort = 'Top Rated';
  String _departmentFilter = 'All Departments'; // New state for department filter
  String _searchQuery = ''; // New state for search query

  // Stores user-assigned ratings, overriding the default instructor rating for the current user.
  final Map<String, double> _userRatings = <String, double>{};

  // Stores the globally updated total rating sum and total review count for each instructor.
  final Map<String, _InstructorDynamicData> _dynamicInstructorData = <String, _InstructorDynamicData>{};

  // For efficient lookup of initial instructor data by ID.
  final Map<String, Instructor> _initialInstructorsById = <String, Instructor>{};

  InstructorRatingsData() {
    // Initialize dynamic data from mock instructors.
    // The totalRatingSum is calculated as the initial average rating multiplied by the initial number of reviews.
    for (final Instructor instructor in _mockInstructors) {
      _initialInstructorsById[instructor.id] = instructor;
      _dynamicInstructorData[instructor.id] = _InstructorDynamicData(
        totalRatingSum: instructor.rating * instructor.reviews,
        reviews: instructor.reviews,
      );
    }
  }

  String get campus => _campus;
  String get sort => _sort;
  String get departmentFilter => _departmentFilter; // Getter for department filter
  String get searchQuery => _searchQuery; // Getter for search query

  // Calculates and returns the effective global average rating for an instructor,
  // based on the dynamically updated total rating sum and review count.
  double getEffectiveRating(String instructorId) {
    final _InstructorDynamicData? dynamicData = _dynamicInstructorData[instructorId];
    final Instructor? initialInstructor = _initialInstructorsById[instructorId];

    if (dynamicData == null || initialInstructor == null) {
      // This case should ideally not happen with correctly initialized data.
      return 0.0;
    }

    if (dynamicData.reviews > 0) {
      return dynamicData.totalRatingSum / dynamicData.reviews;
    } else {
      // If dynamic reviews count drops to 0, use the initial mock data's average rating as a fallback.
      return initialInstructor.rating;
    }
  }

  // Returns the current global review count for an instructor.
  int getInstructorReviews(String instructorId) {
    return _dynamicInstructorData[instructorId]?.reviews ?? _initialInstructorsById[instructorId]!.reviews;
  }

  List<Instructor> get instructors {
    List<Instructor> items = _mockInstructors
        .where((Instructor i) => _campus == 'All Campuses' || i.campus == _campus)
        .where((Instructor i) => _departmentFilter == 'All Departments' || i.department == _departmentFilter)
        .where((Instructor i) =>
            _searchQuery.isEmpty || i.name.toLowerCase().contains(_searchQuery.toLowerCase())) // Apply search filter
        .toList();

    items.sort((Instructor a, Instructor b) {
      // Use the effective global average rating for sorting.
      final double ratingA = getEffectiveRating(a.id);
      final double ratingB = getEffectiveRating(b.id);

      // Use the dynamic review count for sorting.
      final int reviewsA = getInstructorReviews(a.id);
      final int reviewsB = getInstructorReviews(b.id);

      switch (_sort) {
        case 'Top Rated':
          return ratingB.compareTo(ratingA); // Sort by effective average rating
        case 'Most Reviews':
          return reviewsB.compareTo(reviewsA);
        case 'A-Z':
          return a.name.compareTo(b.name);
        default:
          return 0;
      }
    });
    return items;
  }

  void setCampus(String? newCampus) {
    if (newCampus != null && _campus != newCampus) {
      _campus = newCampus;
      notifyListeners();
    }
  }

  void setSort(String? newSort) {
    if (newSort != null && _sort != newSort) {
      _sort = newSort;
      notifyListeners();
    }
  }

  // Setter for department filter
  void setDepartmentFilter(String? newDepartmentFilter) {
    if (newDepartmentFilter != null && _departmentFilter != newDepartmentFilter) {
      _departmentFilter = newDepartmentFilter;
      notifyListeners();
    }
  }

  // Setter for search query
  void setSearchQuery(String newQuery) {
    if (_searchQuery != newQuery) {
      _searchQuery = newQuery;
      notifyListeners();
    }
  }

  // Returns the explicit rating set by the current user for a given instructor,
  // or 0.0 if no rating has been set by the user.
  double getUserRating(String instructorId) {
    return _userRatings[instructorId] ?? 0.0;
  }

  // Sets or updates the user's explicit rating for an instructor and
  // updates the global instructor total rating sum and review count.
  void setUserRating(String instructorId, double newRatingFromUser) {
    final _InstructorDynamicData? dynamicData = _dynamicInstructorData[instructorId];
    if (dynamicData == null) {
      return;
    }

    // Get the rating previously set by THIS USER (0.0 if not set)
    final double oldUserRatingForInstructor = _userRatings[instructorId] ?? 0.0;

    // Update the current user's explicit rating override.
    if (newRatingFromUser == 0.0) {
      _userRatings.remove(instructorId); // Clear the user's personal rating
    } else {
      _userRatings[instructorId] = newRatingFromUser; // Set or change the user's personal rating
    }

    // Update the global totalRatingSum and review count (_dynamicInstructorData)
    // based on the specific rules.

    // Case A: User is giving a new positive rating (previously 0.0, now > 0.0).
    // Reviews should increase by one and the new rating is added to the sum.
    if (oldUserRatingForInstructor == 0.0 && newRatingFromUser > 0.0) {
      dynamicData.totalRatingSum += newRatingFromUser;
      dynamicData.reviews += 1;
    }
    // Case B: User is changing an existing positive rating to another positive rating (old > 0.0, new > 0.0).
    // The number of reviews should NOT change, but the total sum should be adjusted by removing the old rating and adding the new one.
    else if (oldUserRatingForInstructor > 0.0 && newRatingFromUser > 0.0) {
      dynamicData.totalRatingSum -= oldUserRatingForInstructor;
      dynamicData.totalRatingSum += newRatingFromUser;
      // Reviews count remains the same.
    }
    // Case C: User is clearing a previously set positive rating (old > 0.0, new == 0.0).
    // Reviews should decrease by one and the global total sum should be reduced by the old rating.
    else if (oldUserRatingForInstructor > 0.0 && newRatingFromUser == 0.0) {
      dynamicData.totalRatingSum -= oldUserRatingForInstructor;
      dynamicData.reviews -= 1;

      // Ensure that if reviews drop to 0 or below, totalRatingSum is also 0.
      if (dynamicData.reviews <= 0) {
        dynamicData.totalRatingSum = 0.0;
        dynamicData.reviews = 0; // Explicitly clamp to 0 if it somehow goes negative
      }
    }

    notifyListeners();
  }
}

class InstructorRatingsPage extends StatelessWidget {
  const InstructorRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/courses');
          },
        ),
        title: const Text('Instructor Ratings'), // Simplified title
        actions: <Widget>[
          // _CampusDropdown moved to actions with a small right padding
          const _CampusDropdown(),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const _FilterAndSortSection(), // Use the new widget here
              ),
            ),
            Consumer<InstructorRatingsData>(
              builder: (BuildContext context, InstructorRatingsData data, Widget? child) {
                final List<Instructor> items = data.instructors;
                return SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
                  itemBuilder: (BuildContext context, int index) {
                    final Instructor i = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: _InstructorCard(instructor: i),
                    );
                  },
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

/// New StatefulWidget to combine Search and Sort/Filter controls.
class _FilterAndSortSection extends StatefulWidget {
  const _FilterAndSortSection();

  @override
  State<_FilterAndSortSection> createState() => _FilterAndSortSectionState();
}

class _FilterAndSortSectionState extends State<_FilterAndSortSection> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current search query from data model
    _searchController = TextEditingController(
      text: Provider.of<InstructorRatingsData>(context, listen: false).searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InstructorRatingsData data = Provider.of<InstructorRatingsData>(context);
    return Column(
      children: <Widget>[
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by instructor name',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      data.setSearchQuery('');
                      FocusScope.of(context).unfocus(); // Dismiss keyboard
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          onChanged: (String value) {
            data.setSearchQuery(value);
          },
        ),
        const SizedBox(height: 8),
        const _SortBar(),
      ],
    );
  }
}

class _SortBar extends StatelessWidget {
  const _SortBar();

  @override
  Widget build(BuildContext context) {
    final InstructorRatingsData data = Provider.of<InstructorRatingsData>(context);
    final TextTheme text = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Text('Sort by', style: text.bodyMedium),
        const SizedBox(width: 12),
        DropdownButton<String>(
          value: data.sort,
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'Top Rated', child: Text('Top Rated')),
            DropdownMenuItem<String>(value: 'Most Reviews', child: Text('Most Reviews')),
            DropdownMenuItem<String>(value: 'A-Z', child: Text('A-Z')),
          ],
          onChanged: (String? v) => data.setSort(v),
        ),
        const Spacer(),
        Text('Department', style: text.bodyMedium), // New label for department filter
        const SizedBox(width: 12),
        DropdownButton<String>(
          value: data.departmentFilter, // Use the new department filter state
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'All Departments', child: Text('All Departments')),
            DropdownMenuItem<String>(value: 'FENS', child: Text('FENS')),
            DropdownMenuItem<String>(value: 'FASS', child: Text('FASS')),
            DropdownMenuItem<String>(value: 'FMAN', child: Text('FMAN')),
            DropdownMenuItem<String>(value: 'SL', child: Text('SL')),
          ],
          onChanged: (String? v) => data.setDepartmentFilter(v), // Call the new setter
        ),
      ],
    );
  }
}

class _InstructorCard extends StatelessWidget {
  final Instructor instructor;

  const _InstructorCard({required this.instructor});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final InstructorRatingsData data = Provider.of<InstructorRatingsData>(context);

    // Get the rating explicitly set by the user, for the interactive stars.
    final double userRating = data.getUserRating(instructor.id);
    // Get the effective global average rating to display in the header.
    final double displayRating = data.getEffectiveRating(instructor.id);
    // Get the dynamic review count to display in the header.
    final int displayReviews = data.getInstructorReviews(instructor.id);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
        ),
        boxShadow: <BoxShadow>[
          if (!isDark)
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Avatar(url: instructor.avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: _NameAndDept(name: instructor.name, dept: instructor.department),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _Stars(rating: displayRating), // Use the effective global average rating here
                  const SizedBox(height: 4),
                  Text('$displayReviews reviews', // Use dynamic reviews here
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _UserRatingStars(
            instructorId: instructor.id,
            currentRating: userRating, // Pass the explicit user rating for the interactive stars
          ),
        ],
      ),
    );
  }
}

class _UserRatingStars extends StatelessWidget {
  final String instructorId;
  final double currentRating;

  const _UserRatingStars({
    required this.instructorId,
    required this.currentRating,
  });

  @override
  Widget build(BuildContext context) {
    final InstructorRatingsData data = Provider.of<InstructorRatingsData>(context, listen: false);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (int index) {
        final double starValue = (index + 1).toDouble();
        return GestureDetector(
          onTap: () {
            // If the user clicks the same star as their current rating, set to 0.0 (no rating)
            // Otherwise, set to the star's value.
            final double newRating = starValue == currentRating ? 0.0 : starValue;
            data.setUserRating(instructorId, newRating);
          },
          child: Icon(
            starValue <= currentRating ? Icons.star_rounded : Icons.star_border_rounded,
            size: 24, // Slightly larger for interaction
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      }),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String url;
  const _Avatar({required this.url});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundImage: NetworkImage(url),
      onBackgroundImageError: (Object error, StackTrace? stackTrace) {
        // Optional: handle image loading errors, e.g., show a placeholder icon.
        // debugPrint('Error loading image: $error');
      },
      child: Container(),
    );
  }
}

class _NameAndDept extends StatelessWidget {
  final String name;
  final String dept;
  const _NameAndDept({required this.name, required this.dept});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                )),
        const SizedBox(height: 2),
        Text(dept, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating; // 0..5
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final int full = rating.floor();
    final bool half = (rating - full) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (int i) {
        IconData iconData;
        if (i < full) {
          iconData = Icons.star_rounded;
        } else if (i == full && half) {
          iconData = Icons.star_half_rounded;
        } else {
          iconData = Icons.star_border_rounded;
        }
        return Icon(iconData, size: 18, color: Colors.amber);
      }),
    );
  }
}

// ======= Data layer & mock data =======

class Instructor {
  final String id; // Unique identifier for each instructor
  final String name;
  final String department;
  final String campus;
  final double rating; // This is the initial default average rating from mock data
  final int reviews; // This is the initial default reviews count from mock data
  final String avatarUrl;

  const Instructor({
    required this.id,
    required this.name,
    required this.department,
    required this.campus,
    required this.rating,
    required this.reviews,
    required this.avatarUrl,
  });
}

final List<Instructor> _mockInstructors = <Instructor>[
  const Instructor(
    id: 'instructor_001',
    name: 'Saima Gul',
    department: 'FASS',
    campus: 'All Campuses',
    rating: 4.8,
    reviews: 3,
    avatarUrl:
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=256&auto=format&fit=crop',
  ),
  const Instructor(
    id: 'instructor_002',
    name: 'Mike Chan',
    department: 'FENS',
    campus: 'All Campuses',
    rating: 4.6,
    reviews: 4,
    avatarUrl:
        'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?q=80&w=256&auto=format&fit=crop',
  ),
  const Instructor(
    id: 'instructor_003',
    name: 'Elif Aydın',
    department: 'SL',
    campus: 'Sabancı',
    rating: 4.9,
    reviews: 6,
    avatarUrl:
        'https://images.unsplash.com/photo-1520975922284-9bcd1917c1a5?q=80&w=256&auto=format&fit=crop',
  ),
  const Instructor(
    id: 'instructor_004',
    name: 'Ahmet Kaya',
    department: 'FMAN',
    campus: 'Sabancı',
    rating: 4.3, // Initial average rating
    reviews: 7, // Initial review count
    avatarUrl:
        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
  ),
];

// ======= Small helper widget =======

class _CampusDropdown extends StatelessWidget {
  const _CampusDropdown();

  @override
  Widget build(BuildContext context) {
    final InstructorRatingsData data = Provider.of<InstructorRatingsData>(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: data.campus,
        items: const <DropdownMenuItem<String>>[
          DropdownMenuItem<String>(value: 'All Campuses', child: Text('All Campuses')),
          DropdownMenuItem<String>(value: 'Sabancı', child: Text('Sabancı')),
          DropdownMenuItem<String>(value: 'Orta Kampüs', child: Text('Orta Kampüs')),
        ],
        onChanged: (String? v) => data.setCampus(v),
      ),
    );
  }
}

