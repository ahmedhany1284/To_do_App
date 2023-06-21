import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_list/modules/archived_tasks/archived_tasks_screen.dart';

class Homelayout extends StatefulWidget {
  const Homelayout({Key? key}) : super(key: key);

  @override
  State<Homelayout> createState() => _HomelayoutState();
}

// 1- create database
// 2-create table
// 3- open database
// 4- insert to data base
// 5- get from database
// 6- update from database
// 7- delete from database

class _HomelayoutState extends State<Homelayout> {
  int cur_var=0;
  List<Widget>screen=[New_Task_Screen(), Done_Task_Screen(), Archived_Task_Screen(),];

  List<String>titles=['New Tasks','Done Tasks', 'Archived Tasks'];
  @override
  void initState() {
    super.initState();
    createDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(titles[cur_var]),
      ),
      body: screen[cur_var],

      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          var name= await getname();
          print(name);
        },
        child: Icon(
          Icons.add,
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

  Future<String> getname() async {
    return 'Ahmed Hany';
  }


  void createDatabase() async{
    var database=await openDatabase(
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
        print('database opened');
    },
    );
  }



}


