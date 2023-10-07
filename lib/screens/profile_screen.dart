import 'package:employee_attendance/models/department.dart';
import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/services/auth_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DbService>(
      builder: (BuildContext context, dbService, Widget? child) {
        //Preventing to call functions multiple times
        dbService.allDepartments.isEmpty
            ? dbService.getAllDepartments()
            : null;
        return FutureBuilder(
          future: dbService.getUserData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              UserModel user = snapshot.data!;
              nameController.text.isEmpty
                  ? nameController.text = user.name ?? ''
                  : null;
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.topRight,
                          child: TextButton.icon(
                              onPressed: (){
                                dbService.clearData();
                                Provider.of<AuthService>(context, listen: false).signOut();
                              },
                              icon: Icon(Icons.logout),
                              label: Text("Sign out")
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 80),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Text("Employee ID: ${user.employeeId}"),
                        const SizedBox(height: 30,),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              label: Text("Full Name"),
                              border: OutlineInputBorder()
                          ),
                        ),
                        const SizedBox(height: 15,),
                        dbService.allDepartments.isEmpty
                            ? const LinearProgressIndicator()
                            : SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()
                            ),
                            value: user.department ?? dbService.allDepartments.first.id,
                            items: dbService.allDepartments.map((DepartmentModel item) {
                              return DropdownMenuItem(
                                  value: item.id,
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                        fontSize: 20
                                    ),
                                  )
                              );
                            }).toList(),
                            onChanged: (selectedValue) {
                              dbService.employeeDepartment = selectedValue;
                            },
                          ),
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                dbService.updateProfile(nameController.text, context);
                              },
                              child: const Text(
                                "Update profile",
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return const Center(
                  child: CircularProgressIndicator()
              );
            }
          },

        );
      },

    );
  }
}
