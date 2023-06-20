import 'package:flutter/material.dart';
import 'package:to_do_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_list/modules/archived_tasks/archived_tasks_screen.dart';

class Homelayout extends StatefulWidget {
  const Homelayout({Key? key}) : super(key: key);

  @override
  State<Homelayout> createState() => _HomelayoutState();
}

class _HomelayoutState extends State<Homelayout> {
  int cur_var=0;
  List<Widget>screen=[New_Task_Screen(), Done_Task_Screen(), Archived_Task_Screen(),];

  List<String>titles=['New Tasks','Done Tasks', 'Archived Tasks'];
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

  Future<String> getname() async
  {
    return 'Ahmed Hany';
  }
}
