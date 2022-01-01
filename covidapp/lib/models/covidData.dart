class CovidData {
  final int cases;
  final String date;

  CovidData({required this.cases, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'cases': cases,
      'date': date,
    };
  }
}
