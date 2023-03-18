import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

import '../shared/constants.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>(); // ***********
  var formKey = GlobalKey<FormState>(); // ***********
  dynamic titleController = TextEditingController();
  dynamic timeController = TextEditingController();
  dynamic dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = BlocProvider.of<AppCubit>(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        if (state is AppInsertDatabaseState)
          Navigator.pop(context);
      },
      builder: (context, state) => Scaffold(
        key: scaffoldKey, //  ********************************
        appBar: AppBar(
          title: Text(cubit.screens[cubit.currentIndex]['title']),
        ),
        body: ConditionalBuilder(
          condition: state is! AppGetDatabaseLoadingState,
          builder: (BuildContext context) {
            return cubit.screens[cubit.currentIndex]['screen'];
          },
          fallback: (context) => Center(child: CircularProgressIndicator()),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline), label: 'Done',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined), label: 'Archived',
            )
          ],
          onTap: (index) {
            cubit.changeIndex(index);
          },
          currentIndex: cubit.currentIndex,
          showUnselectedLabels: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (cubit.bottomSheetShown == false) {
              scaffoldKey.currentState!.showBottomSheet(// ***************
                      (context) => Container(
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(                 //  ***********************
                                key: formKey,              //  *********************
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.title),
                                        labelText: 'Task Title',
                                      ),
                                      keyboardType: TextInputType.text,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'title must not be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                        labelText: 'Task Time',
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'time must not be empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          value != null
                                              ? timeController.text = value
                                                  .format(context)
                                                  .toString()
                                              : null;
                                          print(timeController.text);
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.calendar_today),
                                        labelText: 'Task Date',
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'date must not be empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2023-10-01'),
                                        ).then((value) {
                                          value != null ? dateController.text = DateFormat.yMMMd().format(value)
                                              : null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )).closed.then((value) {
                cubit.changeBottomSheetState(sheetIsShown: false, icon: Icons.edit);
              });
              cubit.changeBottomSheetState(sheetIsShown: true, icon: Icons.add);
            } else {
              if (formKey.currentState!.validate())   //  ***************
              {
                cubit.insertToDatabase(titleController.text, dateController.text, timeController.text);

                // insertToDatabase2(titleController.text, dateController.text,
                //         timeController.text)
                //     .then((value) {
                //   Navigator.pop(context);
                //   bottomSheetShown = false;
                //   // setState(() {
                //   // isBottomSheetShown=false;
                //   // fabIcon=Icons.edit;
                //   // });
                // });
              }
            }
          },
          child: Icon(cubit.fabIcon),
        ),
      ),
    );
  }


  // Future insertToDatabase2(String title, String date, String time) async {
  //   return await database!.rawInsert(
  //           'INSERT INTO tasks(title,date,time,status) VALUES("$title", "$date", "$time", "new")')
  //       .then((value) {
  //     print('$value inserted successfully');
  //   }).catchError((error) {
  //     print('Error when inserting new record ${error.toString()}');
  //   });
  // }

}
