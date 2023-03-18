import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/bloc_observer.dart';
import 'package:todo/shared/cubit/cubit.dart';

import 'layout/HomeLayout.dart';

void main(){
   // WidgetsFlutterBinding.ensureInitialized();
   // createDatabase();
  Bloc.observer=MyBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit()..createDatabase(),  // because AppCubit isn't a real object (not saved in a variable)
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeLayout(),
      ),
    );
  }
}