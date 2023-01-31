import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/schedule_model.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage(
      {Key? key,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.alldayFlag})
      : super(key: key);

  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool alldayFlag;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final StartingDayOfWeek _startingDayOfWeek = StartingDayOfWeek.monday;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateFormat outputFormat = DateFormat('yyyy年MM月', 'ja');
  Map<DateTime, List> _eventsList = {};
  final List<Schedule> _scheduleList = [
    Schedule(
      title: 'テスト1テスト1テスト1テスト1テスト1テスト1テスト1',
      startTime: DateTime(2023, 1, 25, 10, 00),
      endTime: DateTime(2023, 1, 25, 12, 00),
      alldayFlag: false,
    ),
    Schedule(
      title: 'テスト2',
      startTime: DateTime(2023, 1, 25, 12, 00),
      endTime: DateTime(2023, 1, 25, 14, 00),
      alldayFlag: false,
    ),
    Schedule(
      title: 'テスト3',
      startTime: DateTime(2023, 1, 25, 14, 00),
      endTime: DateTime(2023, 1, 25, 16, 00),
      alldayFlag: true,
    ),
  ];

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _eventsList = {
      DateTime.now().subtract(Duration(days: 2)): ['Test A', 'Test B'],
      DateTime.now(): ['Test C', 'Test D', 'Test E', 'Test F'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEvent(DateTime day) {
      return _events[day] ?? [];
    }

    final _pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.9,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("カレンダー"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              locale: 'ja_JP',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  titleCentered: true,
                  headerPadding: EdgeInsets.only(top: 20, bottom: 20)),
              startingDayOfWeek: _startingDayOfWeek,
              calendarBuilders: CalendarBuilders(
                dowBuilder: (_, day) {
                  if (day.weekday == DateTime.sunday) {
                    final text = DateFormat.E('ja').format(day);
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (day.weekday == DateTime.saturday) {
                    final text = DateFormat.E('ja').format(day);
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.blue),
                      ),
                    );
                  }
                  return null;
                },
              ),
              eventLoader: getEvent,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  getEvent(selectedDay);
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 650,
                            child: PageView(
                              controller: _pageController,
                              children: [
                                Material(
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(DateFormat('yyyy-MM-dd')
                                                .format(_selectedDay!.subtract(Duration(days: 1)))
                                                .toString()
                                                .replaceAll('-', '/') +
                                            '  (${DateFormat.E('ja').format(_selectedDay!.subtract(Duration(days: 1)))})'),
                                        IconButton(
                                            onPressed: () {
                                              print('追加ページに飛ぶ');
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.blue,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 400,
                                      height: 500,
                                      child: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Column(
                                              children: [],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Column(children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                                          height: 80,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black12,
                                                      style: BorderStyle.solid))),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                DateFormat('yyyy-MM-dd')
                                                        .format(_selectedDay!)
                                                        .toString()
                                                        .replaceAll('-', '/') +
                                                    '  (${DateFormat.E('ja').format(_selectedDay!)})',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    print('追加ページに飛ぶ');
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.blue,
                                                    size: 30,
                                                  ))
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            width: 400,
                                            height: 500,
                                            child: SingleChildScrollView(
                                              child: SizedBox(
                                                height: 320,
                                                child: ListView.builder(
                                                    itemCount: _scheduleList.length,
                                                    itemBuilder: (context, i) => Container(
                                                          child: InkWell(
                                                            child: Container(
                                                              height: 80,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Colors.black12,
                                                                          style:
                                                                              BorderStyle.solid))),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(8.0),
                                                                    child: (_scheduleList[i]
                                                                                .alldayFlag ==
                                                                            true)
                                                                        ? Text(
                                                                            '終日',
                                                                            style: TextStyle(),
                                                                          )
                                                                        : Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                  '${_scheduleList[i].startTime.toString().substring(10, 16)}',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                          16)),
                                                                              Text(
                                                                                  '${_scheduleList[i].endTime.toString().substring(10, 16)}',
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                          16)),
                                                                            ],
                                                                          ),
                                                                  ),
                                                                  Container(
                                                                      height: 70,
                                                                      color: Colors.blue,
                                                                      width: 4,
                                                                      child: VerticalDivider()),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.only(left: 15.0),
                                                                    child: Container(
                                                                      child: Text(
                                                                        _scheduleList[i]
                                                                            .title
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(fontSize: 20),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                              ),
                                            )),
                                      ]),
                                    ),
                                  ),
                                ),
                                Material(
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(DateFormat('yyyy-MM-dd')
                                                .format(_selectedDay!.subtract(Duration(days: -1)))
                                                .toString()
                                                .replaceAll('-', '/') +
                                            '  (${DateFormat.E('ja').format(_selectedDay!.subtract(Duration(days: -1)))})'),
                                        IconButton(
                                            onPressed: () {
                                              print('追加ページに飛ぶ');
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.blue,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 400,
                                      height: 500,
                                      child: SingleChildScrollView(
                                          child: ListView(
                                        shrinkWrap: true,
                                        children: getEvent(_selectedDay!)
                                            .map((event) => ListTile(
                                                  title: Text(event.toString()),
                                                ))
                                            .toList(),
                                      )),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ],
        ),
      ),
    );
  }
}
