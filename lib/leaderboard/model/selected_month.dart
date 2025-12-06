class SelectedMonth {
  final int year;
  final int month;

  const SelectedMonth({required this.year, required this.month});

  String get displayName {
    const monthNames = [
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
    return '${monthNames[month - 1]} $year';
  }

  bool get isCurrentMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
}
