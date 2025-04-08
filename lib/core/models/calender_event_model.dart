class CalenderEventModel {
  final String date;
  final String event;

  CalenderEventModel({
    required this.date,
    required this.event,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'event': event,
    };
  }
  factory CalenderEventModel.fromMap(Map<String, dynamic> map) {
    return CalenderEventModel(
        date: map['date'],
      event: map['event']
    );
  }
}
