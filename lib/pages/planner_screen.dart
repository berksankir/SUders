import 'package:flutter/material.dart';
import 'package:suders/utils/app_colors.dart';
import 'package:suders/utils/app_text_styles.dart';
import 'package:suders/utils/app_paddings.dart';

const Color kAccent = Color(0xFFFFC107);
const Color kEventExam = Color(0xFFE57373);
const Color kEventProject = Color(0xFFBA68C8);
const Color kEventAssignment = Color(0xFF81C784);
const Color kEventOther = Color(0xFFFFB74D);

enum CalendarView { month, week, list }

class CalendarEvent {
  final DateTime date;
  final String title;
  final String type;
  final String time;
  final String location;

  const CalendarEvent({
    required this.date,
    required this.title,
    required this.type,
    required this.time,
    required this.location,
  });
}

class AcademicCalendarPage extends StatefulWidget {
  const AcademicCalendarPage({Key? key}) : super(key: key);

  @override
  State<AcademicCalendarPage> createState() => _AcademicCalendarPageState();
}

class _AcademicCalendarPageState extends State<AcademicCalendarPage> {
  int _year = 2024;
  int _month = 10;
  CalendarView _view = CalendarView.month;
  String _filter = 'All';
  int _selectedDay = 5;

  List<CalendarEvent> _events = [];

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _events = [
      CalendarEvent(
        date: DateTime(2024, 10, 4),
        title: 'CS 201 Assignment 2',
        type: 'Assignment',
        time: '11:59 PM',
        location: 'Canvas',
      ),
      CalendarEvent(
        date: DateTime(2024, 10, 5),
        title: 'SPS 101 Midterm',
        type: 'Exam',
        time: '10:00 AM',
        location: 'FASS G052',
      ),
      CalendarEvent(
        date: DateTime(2024, 10, 10),
        title: 'CS 204 Project Milestone 1',
        type: 'Project',
        time: '11:59 PM',
        location: 'Canvas',
      ),
      CalendarEvent(
        date: DateTime(2024, 10, 16),
        title: 'NS 101 Homework 3',
        type: 'Assignment',
        time: '11:59 PM',
        location: 'Canvas',
      ),
      CalendarEvent(
        date: DateTime(2024, 10, 16),
        title: 'Club Meeting',
        type: 'Other',
        time: '18:00',
        location: 'Cinema Hall',
      ),
      CalendarEvent(
        date: DateTime(2024, 10, 27),
        title: 'MATH 203 Midterm',
        type: 'Exam',
        time: '09:00 AM',
        location: 'FENS G077',
      ),
      CalendarEvent(
        date: DateTime(2024, 11, 3),
        title: 'CS 300 Project Proposal',
        type: 'Project',
        time: '11:59 PM',
        location: 'Canvas',
      ),
      CalendarEvent(
        date: DateTime(2024, 9, 29),
        title: 'Orientation Day',
        type: 'Other',
        time: '10:00 AM',
        location: 'Campus',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(),
                _buildViewSegmentedControl(),
                if (_view == CalendarView.month) _buildCalendarPicker(),
                _buildFilterChips(),
                Expanded(
                  child: _buildEventsArea(),
                ),
              ],
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                backgroundColor: kAccent,
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.black,
                ),
                onPressed: _openAddEventDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddEventDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final locationController = TextEditingController();
    String selectedType = 'Exam';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppColors.card,
              title: const Text('Add Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(
                          value: 'Exam',
                          child: Text('Exam'),
                        ),
                        DropdownMenuItem(
                          value: 'Project',
                          child: Text('Project'),
                        ),
                        DropdownMenuItem(
                          value: 'Assignment',
                          child: Text('Assignment'),
                        ),
                        DropdownMenuItem(
                          value: 'Other',
                          child: Text('Other'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setStateDialog(() {
                          selectedType = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        hintText: 'Time (e.g. 10:00 AM)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: 'Location',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${_monthNames[_month - 1]} $_selectedDay, $_year',
                      style: AppTextStyles.small,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;
                    setState(() {
                      _events.add(
                        CalendarEvent(
                          date: DateTime(_year, _month, _selectedDay),
                          title: titleController.text.trim(),
                          type: selectedType,
                          time: timeController.text.trim().isEmpty
                              ? 'TBA'
                              : timeController.text.trim(),
                          location: locationController.text.trim().isEmpty
                              ? 'TBA'
                              : locationController.text.trim(),
                        ),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      if (_month == 1) {
        _month = 12;
        _year -= 1;
      } else {
        _month -= 1;
      }
      _selectedDay = 1;
    });
  }

  void _goToNextMonth() {
    setState(() {
      if (_month == 12) {
        _month = 1;
        _year += 1;
      } else {
        _month += 1;
      }
      _selectedDay = 1;
    });
  }

  Widget _buildTopBar() {
    final monthName = _monthNames[_month - 1];
    final title = '$monthName $_year';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/courses');
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.textMain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.sectionTitle,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: _goToNextMonth,
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: AppColors.textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewSegmentedControl() {
    final labelColorInactive = AppColors.textSecondary;
    final background = AppColors.cardAlt;

    Widget buildSegment(CalendarView view, String label) {
      final selected = _view == view;
      final selectedBg = AppColors.card;

      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _view = view;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 36,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: selected ? selectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selected
                  ? [
                BoxShadow(
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                  color: Colors.black.withOpacity(0.05),
                ),
              ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: selected
                    ? AppColors.textMain
                    : labelColorInactive,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            buildSegment(CalendarView.month, 'Month'),
            buildSegment(CalendarView.week, 'Week'),
            buildSegment(CalendarView.list, 'List'),
          ],
        ),
      ),
    );
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  List<_DayModel> _generateMonthGridDays() {
    final List<_DayModel> result = [];

    final int daysCurrent = _daysInMonth(_year, _month);
    final DateTime firstDay = DateTime(_year, _month, 1);
    final int firstWeekday = firstDay.weekday;
    final int leading = firstWeekday % 7;

    final int prevYear = _month == 1 ? _year - 1 : _year;
    final int prevMonth = _month == 1 ? 12 : _month - 1;
    final int prevDays = _daysInMonth(prevYear, prevMonth);

    for (int i = 0; i < leading; i++) {
      final day = prevDays - leading + 1 + i;
      result.add(_buildDayModel(prevYear, prevMonth, day, false));
    }

    for (int day = 1; day <= daysCurrent; day++) {
      result.add(_buildDayModel(_year, _month, day, true));
    }

    const int totalCells = 42;
    final int trailing = totalCells - result.length;
    final int nextYear = _month == 12 ? _year + 1 : _year;
    final int nextMonth = _month == 12 ? 1 : _month + 1;

    for (int day = 1; day <= trailing; day++) {
      result.add(_buildDayModel(nextYear, nextMonth, day, false));
    }

    return result;
  }

  _DayModel _buildDayModel(int year, int month, int day, bool isCurrentMonth) {
    final dotsEvents = _events.where((e) {
      return e.date.year == year &&
          e.date.month == month &&
          e.date.day == day &&
          _matchFilter(e);
    }).toList();

    final List<Color> dotColors = dotsEvents.map((e) => _colorForType(e.type)).toSet().toList();

    return _DayModel(
      year: year,
      month: month,
      day: day,
      isCurrentMonth: isCurrentMonth,
      dots: dotColors,
    );
  }

  Widget _buildCalendarPicker() {
    final mutedColor = AppColors.textMuted;
    final normalTextColor = AppColors.textMain;

    final days = _generateMonthGridDays();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Row(
            children: const [
              _WeekdayLabel('S'),
              _WeekdayLabel('M'),
              _WeekdayLabel('T'),
              _WeekdayLabel('W'),
              _WeekdayLabel('T'),
              _WeekdayLabel('F'),
              _WeekdayLabel('S'),
            ],
          ),
          const SizedBox(height: 4),
          GridView.count(
            crossAxisCount: 7,
            crossAxisSpacing: 0,
            mainAxisSpacing: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: days.map((d) {
              final isSelected = d.isCurrentMonth &&
                  d.year == _year &&
                  d.month == _month &&
                  d.day == _selectedDay;
              return _DayCell(
                model: d,
                isSelected: isSelected,
                normalTextColor: normalTextColor,
                mutedColor: mutedColor,
                onTap: d.isCurrentMonth
                    ? () {
                  setState(() {
                    _selectedDay = d.day;
                  });
                }
                    : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    bool isFilterSelected(String key) => _filter == key;

    Widget chip({
      required String key,
      required String label,
      Widget? leading,
    }) {
      final selected = isFilterSelected(key);
      final bg = selected ? AppColors.primary : AppColors.cardAlt;
      final textColor =
      selected ? AppColors.textMain : AppColors.textSecondary;

      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _filter = key;
            });
          },
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  leading,
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chip(
              key: 'All',
              label: 'All',
              leading: Icon(
                Icons.checklist,
                size: 18,
                color: _filter == 'All' ? Colors.white : Colors.grey.shade700,
              ),
            ),
            chip(
              key: 'Exam',
              label: 'Exam',
              leading: const _Dot(color: kEventExam, size: 8),
            ),
            chip(
              key: 'Project',
              label: 'Project',
              leading: const _Dot(color: kEventProject, size: 8),
            ),
            chip(
              key: 'Assignment',
              label: 'Assignment',
              leading: const _Dot(color: kEventAssignment, size: 8),
            ),
            chip(
              key: 'Other',
              label: 'Other',
              leading: const _Dot(color: kEventOther, size: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsArea() {
    switch (_view) {
      case CalendarView.month:
        return _buildMonthEvents();
      case CalendarView.week:
        return _buildWeekEvents();
      case CalendarView.list:
        return _buildListEvents();
    }
  }

  Widget _buildMonthEvents() {
    final events = _eventsForDay(_selectedDay);
    final headerText = _formatDateHeader(_selectedDay);

    return _buildEventsContainer(
      child: ListView(
        children: [
          Text(
            headerText,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 12),
          if (events.isEmpty) _buildEmptyState(),
          ...events.map((e) => _buildEventCard(e)).toList(),
        ],
      ),
    );
  }

  Widget _buildWeekEvents() {
    final days = _weekDaysAroundSelected();
    final weekEvents = _events
        .where((e) =>
    e.date.year == _year &&
        e.date.month == _month &&
        days.contains(e.date.day))
        .where(_matchFilter)
        .toList();

    final grouped = _groupByDay(weekEvents);

    return _buildEventsContainer(
      child: Column(
        children: [
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: days.map((d) {
                final selected = d == _selectedDay;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = d;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.cardAlt,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      d.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? AppColors.textMain
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: grouped.isEmpty
                ? ListView(children: [_buildEmptyState()])
                : _buildGroupedListView(grouped),
          ),
        ],
      ),
    );
  }

  Widget _buildListEvents() {
    final filtered = _events
        .where((e) => e.date.year == _year && e.date.month == _month)
        .where(_matchFilter)
        .toList();
    final grouped = _groupByDay(filtered);

    return _buildEventsContainer(
      child: grouped.isEmpty
          ? ListView(children: [_buildEmptyState()])
          : _buildGroupedListView(grouped),
    );
  }

  List<CalendarEvent> _eventsForDay(int day) {
    return _events
        .where((e) =>
    e.date.year == _year &&
        e.date.month == _month &&
        e.date.day == day)
        .where(_matchFilter)
        .toList();
  }

  bool _matchFilter(CalendarEvent e) {
    if (_filter == 'All') return true;
    return e.type == _filter;
  }

  Map<int, List<CalendarEvent>> _groupByDay(List<CalendarEvent> events) {
    final Map<int, List<CalendarEvent>> grouped = {};
    for (final e in events) {
      final day = e.date.day;
      grouped.putIfAbsent(day, () => []).add(e);
    }
    return grouped;
  }

  String _formatDateHeader(int day) {
    final dt = DateTime(_year, _month, day);
    const weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final weekday = weekdayNames[dt.weekday - 1];
    final monthName = _monthNames[dt.month - 1];
    return '$weekday, $monthName $day';
  }

  List<int> _weekDaysAroundSelected() {
    final int daysInMonth = _daysInMonth(_year, _month);
    int start = _selectedDay - 3;
    if (start < 1) start = 1;
    int end = start + 6;
    if (end > daysInMonth) end = daysInMonth;
    return [for (int d = start; d <= end; d++) d];
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'Exam':
        return kEventExam;
      case 'Project':
        return kEventProject;
      case 'Assignment':
        return kEventAssignment;
      case 'Other':
        return kEventOther;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildEventsContainer({
    required Widget child,
  }) {
    final bg = AppColors.cardAlt;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent e) {
    final cardBg = AppColors.card;
    final color = _colorForType(e.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.title,
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 4),
                Text(
                  e.type,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                e.time,
                style: AppTextStyles.small.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                e.location,
                style: AppTextStyles.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            'No deadlines here.',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 4),
          Text(
            'Take a break!',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedListView(
      Map<int, List<CalendarEvent>> grouped) {
    final days = grouped.keys.toList()..sort();
    final List<Widget> children = [];
    for (final day in days) {
      final events = grouped[day]!;
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            _formatDateHeader(day),
            style: AppTextStyles.sectionTitle,
          ),
        ),
      );
      for (final e in events) {
        children.add(_buildEventCard(e));
      }
      children.add(const SizedBox(height: 8));
    }
    return ListView(children: children);
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;

  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final color = AppColors.textSecondary;

    return Expanded(
      child: SizedBox(
        height: 40,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _DayModel {
  final int year;
  final int month;
  final int day;
  final bool isCurrentMonth;
  final List<Color> dots;

  const _DayModel({
    required this.year,
    required this.month,
    required this.day,
    required this.isCurrentMonth,
    this.dots = const [],
  });
}

class _DayCell extends StatelessWidget {
  final _DayModel model;
  final bool isSelected;
  final Color normalTextColor;
  final Color mutedColor;
  final VoidCallback? onTap;

  const _DayCell({
    required this.model,
    required this.isSelected,
    required this.normalTextColor,
    required this.mutedColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = model.isCurrentMonth ? normalTextColor : mutedColor;

    final content = SizedBox(
      height: 48,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.20) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          padding: isSelected ? const EdgeInsets.all(4) : EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    model.day.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Text(
                  model.day.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              if (model.dots.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: model.dots
                      .map(
                        (c) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: _Dot(color: c, size: 4),
                    ),
                  )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (onTap == null) {
      return content;
    }

    return GestureDetector(
      onTap: onTap,
      child: content,
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({required this.color, this.size = 4});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
    );
  }
}