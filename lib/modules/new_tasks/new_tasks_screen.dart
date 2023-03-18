import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';


class NewTasksScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    AppCubit cubit=BlocProvider.of<AppCubit>(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,state){},
      builder:(context,state){
        return taskBuilder(tasks: cubit.newTasks);
    }
    );
  }
}