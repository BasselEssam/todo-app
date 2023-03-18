import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(InitialState());

  int currentIndex = 0;
  Database? database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  List<Map<String, dynamic>> screens = [
    {'screen': NewTasksScreen(), 'title': 'New Tasks'},
    {'screen': DoneTasksScreen(), 'title': 'Done Tasks'},
    {'screen': ArchivedTasksScreen(), 'title': 'Archived Tasks'}
  ];

  void changeIndex(int index)
  {
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase()
  {
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((error) {
            print('Error creating table ${error.toString()}');
          });
        }, onOpen: (database)
        {
          getFromDatabase(database);
          print('database opened');
        },).then((value) {
          database=value;
          emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabase(String title, String date, String time) async
  {
     database!.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO tasks(title,date,time,status) VALUES("$title", "$date", "$time", "new")'
      ).then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });
    });
  }

  void updateDatabase({required String status,required int id})
  {
    database?.rawUpdate('UPDATE tasks SET status = ? WHERE id = ? ',
        ['$status', id]
    ).then((value)
    {
      emit(AppUpdateDatabaseState());
      getFromDatabase(database);
    });
  }

  void deleteData({required int id})
  {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      emit(AppDeleteDatabaseState());
      getFromDatabase(database);
    });
  }
  
  void getFromDatabase(database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['status']=='new')
          newTasks.add(element);
        else if(element['status']=='done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  bool bottomSheetShown = false;
  dynamic fabIcon = Icons.edit;
  void changeBottomSheetState({required bool sheetIsShown,required dynamic icon})
  {
    bottomSheetShown=sheetIsShown;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }

}