

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_list/shared/components/components.dart';
import 'package:to_do_list/shared/components/constants.dart';

class Homelayout extends StatefulWidget {
  const Homelayout({Key? key}) : super(key: key);

  @override
  State<Homelayout> createState() => _HomelayoutState();
}



class _HomelayoutState extends State<Homelayout> {
  int cur_var=0;
  List<Widget>screen=[New_Task_Screen(), Done_Task_Screen(), Archived_Task_Screen(),];

  List<String>titles=['New Tasks','Done Tasks', 'Archived Tasks'];
  late Database database;
  var scaffoldkey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  bool isBottomsheeetShown=false;
  IconData fabicon=Icons.edit;
  var titlecontroller=TextEditingController();
  var timecontroller=TextEditingController();
  var datecontroller=TextEditingController();



  @override
  void initState() {
    super.initState();
    createDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text(titles[cur_var]),
      ),
      body: ConditionalBuilder(
          condition:tasks.length>0 ,
          builder: (context)=>screen[cur_var],
          fallback: (context)=>Center(child: CircularProgressIndicator()),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed:(){
          if(isBottomsheeetShown){

            if(formKey.currentState!.validate()){
              insertToDatabase(
                title: titlecontroller.text,
                time: timecontroller.text,
                date: datecontroller.text,
              ).then((value){
                getDataFromDatabase(database).then((value) {
                  Navigator.pop (context);
                  setState(() {

                    isBottomsheeetShown=false;
                    fabicon=Icons.edit;
                    setState(() {
                      tasks=value;
                    });
                  });
                });

              });
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
              isBottomsheeetShown=false;
              setState(() {
                fabicon=Icons.edit;
              });
            });
            isBottomsheeetShown=true;
            setState(() {
              fabicon=Icons.add;
            });
          }

        },
        child: Icon(
          fabicon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: cur_var,
        onTap: (index)
        {
          setState(() {
            cur_var=index;
          });
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
  }

  // Future<String> getname() async {
  //   return 'Ahmed Hany';
  // }
// 1- create database
// 2-create table
// 3- open database
// 4- insert to data base
// 5- get from database
// 6- update from database
// 7- delete from database



  void createDatabase() async{
    database=await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version){
        // id int
        // title string
        // date string
        // time string
        // status string

        print('database created');
        database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)').then((value) {
          print('table created');

            }).catchError((error){
             print('error when creating ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDatabase(database).then((value) {
          setState(() {
            tasks=value;
          });
        });
        print('database opened');
    },
    );
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
})async {
    return await database.transaction((txn) async {
      try {
        await txn.rawInsert(
            'INSERT INTO tasks(title,date,time,status) VALUES("${title}","${date}","${time}","New")').then((value){
          print('${value}Inserted successfully');

        });
      } catch (error) {
        print('Error when inserting new row: ${error.toString()}');
      }
    });
  }



  Future<List<Map>> getDataFromDatabase(database) async{
    return await database.rawQuery('SELECT * FROM tasks');
  }

}


