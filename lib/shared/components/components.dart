import 'package:flutter/material.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap, // Update the parameter name to onTap
  required String? Function(String?)? validate,
  required String label,
  required IconData icon,
  bool is_clickable=true,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    enabled: is_clickable,
    onFieldSubmitted: onSubmit as void Function(String)?,
    onChanged: onChange as void Function(String)?,
    onTap: onTap as void Function()?,
    validator: validate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map model, context)=> Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children:
    [
      CircleAvatar(
        radius: 40.0,
        child: Text(
            '${model['time']}',
        ),
      ),
      SizedBox(width: 20.0,),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text(
              '${model['title']}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${model['date']}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 20.0,),
      IconButton(
          onPressed: (){
            AppCubit.get(context).updatedata(
                status: 'Done',
                id: model['id'],
            );
          },
          icon: Icon(Icons.check_box),
        color:Colors.green ,
      ),
      IconButton(
          onPressed: (){
            AppCubit.get(context).updatedata(
                status: 'Archive',
                id: model['id'],
            );
          },
          icon: Icon(Icons.archive),
        color: Colors.black45,
      ),
    ],
  ),
);
