String formatUnixTime(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
