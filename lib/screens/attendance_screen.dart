import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<SlideActionState> key = GlobalKey<SlideActionState>();

  @override
  void initState() {
    Provider.of<AttendanceService>(context, listen: false).getTodayAttendance();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendanceService>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Welcome!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.displayMedium!.color,
                  fontSize: 30
                ),
              ),
            ),
            Consumer<DbService>(
                builder: (context, dbService, child) {
                  return FutureBuilder(
                    future: dbService.getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserModel user = snapshot.data!;
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            user.name == ""
                                ? "#${user.employeeId}"
                                : user.name,
                            style: const TextStyle(
                                fontSize: 25
                            ),
                          ),
                        );
                      }
                      else {
                        return const SizedBox(
                          width: 60,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: LinearProgressIndicator(),
                          ),
                        );
                      }
                    },
                  );
                }
            ),
            Container(
              margin: const EdgeInsets.only(top: 32),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Today's Status",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 32),
              height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2)
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check in",
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).textTheme.displayMedium!.color,
                            ),
                          ),
                          const SizedBox(
                            width: 80,
                            child: Divider()
                          ),
                          Text(
                            attendanceService.attendanceModel?.checkIn ?? '--/--',
                            style: const TextStyle(
                                fontSize: 25
                            ),
                          )
                        ],
                      )
                  ),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check out",
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).textTheme.displayMedium!.color,
                            ),
                          ),
                          const SizedBox(
                              width: 80,
                              child: Divider()
                          ),
                          Text(
                            attendanceService.attendanceModel?.checkOut ?? '--/--',
                            style: const TextStyle(
                                fontSize: 25
                            ),
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat("dd MMMM yyyy").format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat("hh:mm:ss a").format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.displayMedium!.color
                    ),
                  ),
                );
              }
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Builder(
                builder: (context) {
                  return SlideAction(
                    text: attendanceService.attendanceModel?.checkIn == null
                        ? "Slide to Check in"
                        : "Slide to Check out",
                    textStyle: TextStyle(
                      color: Theme.of(context).textTheme.displayMedium!.color,
                      fontSize: 18,
                    ),
                    outerColor: Colors.white,
                    innerColor: Theme.of(context).colorScheme.primaryContainer,
                    key: key,
                    onSubmit: () async {
                      await attendanceService.markAttendance(context);
                      key.currentState!.reset();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
