import 'package:college_management/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:college_management/core/constants/app_pallete.dart';
import 'package:college_management/core/models/calender_event_model.dart';
import 'package:college_management/utils/date_validator.dart';
import 'package:college_management/views/helper_classes/custom_snackbar.dart';
import 'package:college_management/views/widgets/custom_button.dart';
import 'package:college_management/views/widgets/custom_date_picker.dart';
import 'package:college_management/views/widgets/custom_text_field.dart';
import '../app/base_view.dart';
import '../view_models/calender_view_model.dart';

//todo hide add event button for non admin users
class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

TextEditingController _dateController = TextEditingController();
TextEditingController _eventController = TextEditingController();

class _CalenderViewState extends State<CalenderView> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BaseView<CalenderViewModel>(
      onModelReady: (CalenderViewModel model) async {
        await model.onModelReady(); // Fetch events from Firebase
      },
      onDispose: (CalenderViewModel model) {
        _eventController.clear();
        _dateController.clear();
      },
      refresh: (CalenderViewModel model) {},
      builder: (context, model, child) {
        // Extract event dates from Firebase data
        List<DateTime> eventDates = model.events.map((event) {
          return DateTime.parse(event.date); // Convert string to DateTime
        }).toList();

        return Scaffold(
          appBar: AppBar(title: const Text("Events"),backgroundColor: AppPalette.violetLt,),
          floatingActionButton: Visibility(
            visible: context.read<AppState>().isAdmin,
            child: FloatingActionButton(
              backgroundColor: AppPalette.violetLt,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(0),
                      content: SizedBox(
                        height: size.height / 2.5,
                        width: size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomDatePicker(
                              labelText: "Select event date.",
                              width: size.width * 0.7,
                              height: size.height * 0.09,
                              dateController: _dateController,
                            ),
                            SizedBox(height: size.height * 0.01),
                            CustomTextField(
                              labelText: "Enter event.",
                              width: size.width * 0.7,
                              height: size.height * 0.09,
                              isPassword: false,
                              textEditingController: _eventController,
                            ),
                            SizedBox(height: size.height * 0.01),
                            CustomButton(
                              label: "Add event",
                              onPressed: () async {
                                if (_dateController.text.isEmpty ||
                                    !DateValidator.isValidDate(
                                        _dateController.text)) {
                                  CustomSnackBar.show(
                                      context, "Select a valid date.");
                                  return;
                                }
                                await model.addEvent(
                                  eventModel: CalenderEventModel(
                                    date: _dateController.text,
                                    event: _eventController.text,
                                  ),
                                );
                                Navigator.pop(context);
                                setState(() {}); // Refresh UI
                              },
                              width: size.width * 0.7,
                              height: size.height * 0.08,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime(2020, 1, 1),
                  lastDay: DateTime(2030, 12, 31),
                  focusedDay: _focusedDay,
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) {
                    return eventDates
                        .any((eventDate) => isSameDay(eventDate, day));
                  },
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.black),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: (day) {
                    return model.events
                        .where((event) =>
                            isSameDay(DateTime.parse(event.date), day))
                        .map((event) => event.event)
                        .toList();
                  },
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  "Events in ${DateFormat('MMMM yyyy').format(_focusedDay)}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.primaryTextColor),
                ),
                Expanded(
                  child: model.events
                          .where((event) =>
                              DateTime.parse(event.date).year ==
                                  _focusedDay.year &&
                              DateTime.parse(event.date).month ==
                                  _focusedDay.month)
                          .isEmpty
                      ? const Center(
                          child: Text(
                          "No events this month.",
                          style: TextStyle(color: AppPalette.primaryTextColor),
                        ))
                      : ListView.builder(
                          itemCount: model.events
                              .where((event) =>
                                  DateTime.parse(event.date).year ==
                                      _focusedDay.year &&
                                  DateTime.parse(event.date).month ==
                                      _focusedDay.month)
                              .length,
                          itemBuilder: (context, index) {
                            var filteredEvents = model.events
                                .where((event) =>
                                    DateTime.parse(event.date).year ==
                                        _focusedDay.year &&
                                    DateTime.parse(event.date).month ==
                                        _focusedDay.month)
                                .toList();
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                leading:const  Icon(Icons.event, color: Colors.blue),
                                title: Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(
                                          filteredEvents[index].date)),
                                  style:const  TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(filteredEvents[index].event),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
