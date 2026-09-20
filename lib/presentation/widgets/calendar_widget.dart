import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/constants/app_colors.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?) onDatesSelected;

  const CalendarWidget({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onDatesSelected,
  });

  static Future<void> show(
    BuildContext context, {
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    required Function(DateTime?, DateTime?) onDatesSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarWidget(
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        onDatesSelected: onDatesSelected,
      ),
    );
  }

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialStartDate;
    _rangeEnd = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Dates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: CalendarFormat.month,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _selectedDay = null;
                  _focusedDay = focusedDay;
                  _rangeStart = start;
                  _rangeEnd = end;
                });
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                rangeHighlightColor: AppColors.primaryLight,
                rangeStartDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                rangeEndDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                widget.onDatesSelected(_rangeStart, _rangeEnd);
                Navigator.pop(context);
              },
              child: const Text('Confirm Dates'),
            ),
          ),
        ],
      ),
    );
  }
}
