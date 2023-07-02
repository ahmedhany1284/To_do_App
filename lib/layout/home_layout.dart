

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_list/shared/components/components.dart';
import 'package:to_do_list/shared/components/constants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';

// 1- create database
// 2-create table
// 3- open database
// 4- insert to data base
// 5- get from database
// 6- update from database
// 7- delete from database


class Homelayout extends StatelessWidget {

  late Database database;
  var scaffoldkey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var titlecontroller=TextEditingController();
  var timecontroller=TextEditingController();
  var datecontroller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state){
          if( state is AppInsertDataBaseState){
            Navigator.pop (context);
          }
        } ,
        builder: (BuildContext context,AppStates state)
        {
          AppCubit cubit=AppCubit.get(context);



          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.cur_var]),
            ),
            body: ConditionalBuilder(
              condition:state is! AppGetDataBaseLoadingState,
              builder: (context)=>cubit.screen[cubit.cur_var],
              fallback: (context)=>Center(child: CircularProgressIndicator()),
            ),

            floatingActionButton: FloatingActionButton(
              onPressed:(){
                if(cubit.isBottomsheeetShown){

                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                      title: titlecontroller.text,
                      time: timecontroller.text,
                      date: datecontroller.text,
                    );

                  }
                }
                else{
                  scaffoldkey.currentState?.showBottomSheet(
                        (context) =>Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              controller: titlecontroller,
                              type: TextInputType.text,
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'title must not be empty';
                                }
                                return null;
                              },
                              label: 'Task Title',
                              icon: Icons.title,
                            ),
                            SizedBox(height: 15.0),
                            defaultFormField(
                              controller: timecontroller,
                              type: TextInputType.datetime,
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value){
                                  timecontroller.text=value!.format(context).toString();
                                });
                              },
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              label: 'Task Time',
                              icon: Icons.watch_later_outlined,
                            ),

                            SizedBox(height: 15.0),
                            defaultFormField(
                              controller: datecontroller,
                              type: TextInputType.datetime,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year+15),
                                ).then((value){
                                  datecontroller.text=DateFormat.yMMMd().format(value!);
                                });
                              },
                              validate: (value){
                                if(value!.isEmpty){
                                  return 'date must not be empty';
                                }
                                return null;
                              },
                              label: 'Task date',
                              icon: Icons.calendar_today,
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                  );
                }

              },
              child: Icon(
                cubit.fabicon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.cur_var,
              onTap: (index)
              {
                cubit.change_Index(index);
              },
              items:
              [
                BottomNavigationBarItem(
                  icon:Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon:Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon:Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archieved',
                ),
              ],
            ),
          );
        } ,
      ),
    );
  }







}




