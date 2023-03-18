import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener:(context,state){},
        builder:(context,state){
          AppCubit cubit=BlocProvider.of<AppCubit>(context);
          return taskBuilder(tasks: cubit.doneTasks);
        }
    );
  }
}