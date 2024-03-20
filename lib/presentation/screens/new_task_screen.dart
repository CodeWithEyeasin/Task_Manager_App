import 'package:flutter/material.dart';
import 'package:task_manager_app/presentation/data/models/count_by_status_wrapper.dart';
import 'package:task_manager_app/presentation/data/models/task_list_wrapper.dart';
import 'package:task_manager_app/presentation/data/services/network_caller.dart';
import 'package:task_manager_app/presentation/data/utility/urls.dart';
import 'package:task_manager_app/presentation/screens/add_new_task_screen.dart';
import 'package:task_manager_app/presentation/utils/app_colors.dart';
import 'package:task_manager_app/presentation/widgets/background_widget.dart';
import 'package:task_manager_app/presentation/widgets/snak_bar_message.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/task_card.dart';
import '../widgets/task_counter_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getAllTaskCountByStatusInProgress=false;
  bool _getNewTaskListInProgress= false;
  bool _deleteTaskListInProgress= false;
  bool _updateTaskStatusInProgress= false;
  CountByStatusWrapper _countByStatusWrapper= CountByStatusWrapper();
  TaskListWrapper _newTaskListWrapper=TaskListWrapper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllTaskCountByStatus();
    _getAllNewTaskList();
  }


  void _getDataFromApis(){
    _getAllNewTaskList();
    _getAllTaskCountByStatus();
    _getDataFromApis();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body:  BackgroundWidget(child: Column(
        children: [
          Visibility(
            visible: _getAllTaskCountByStatusInProgress==false,
              replacement: const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
              child: taskCounterSection),
            Expanded(
              child: Visibility(
                visible: _getNewTaskListInProgress == false &&
                    _deleteTaskListInProgress == false && _updateTaskStatusInProgress==false ,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _getDataFromApis();
                  },
                  child: ListView.builder(
                    itemCount: _newTaskListWrapper.taskList?.length??0,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskItem: _newTaskListWrapper.taskList![index],
                        onDelete: (){
                          _deleteTaskById(_newTaskListWrapper.taskList![index].sId!);
                        }, onEdit: (){
                          _showUpdateStatusDialog(_newTaskListWrapper.taskList![index].sId!);
                      },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
      ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          ///todo: refresh home apis after successfully add new tasks
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
        },
        backgroundColor: AppColors.themeColor,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
 Widget get taskCounterSection{
    return  SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemCount: _countByStatusWrapper.listOfTaskByStatusData?.length??0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              return  TaskCounterCard(
                title: _countByStatusWrapper.listOfTaskByStatusData![index].sId??'',
                amount: _countByStatusWrapper.listOfTaskByStatusData![index].sum??0,
              );
            }, separatorBuilder: (_,__){
          return const SizedBox(width: 8,);
        }),
      ),
    );
 }

 void _showUpdateStatusDialog(String id){
    showDialog(context: context, builder: (context){
      return  AlertDialog(
        title: Text('Select status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                ListTile(
                  title: Text('New'),
                  trailing: Icon(Icons.check),
                ),
                ListTile(title: Text('Completed'),onTap: (){
                  _updateTaskById(id, 'Completed');
                  Navigator.pop(context);
                },),
            ListTile(title: Text('Progress'),onTap: (){
              _updateTaskById(id, 'Progress');
              Navigator.pop(context);
            },),
            ListTile(title: Text('Canceled'),onTap: (){
              _updateTaskById(id, 'Canceled');
              Navigator.pop(context);
            },),

          ],
        ),
      );
    });
 }
  

 Future<void> _getAllTaskCountByStatus () async{
   _getAllTaskCountByStatusInProgress = true;
   setState(() {});
   final response =await NetWorkCaller.getRequest(Urls.taskStatusCount);
   if(response.isSuccess){
     _countByStatusWrapper=CountByStatusWrapper.fromJson(response.responseBody);
     _getAllTaskCountByStatusInProgress=false;
     setState(() {});

   }else{
     _getAllTaskCountByStatusInProgress=false;
     setState(() {});
     if(mounted){
       showSnackBarMessage(context, response.errorMessage??'Get task count by status has been failed');

     }
   }
 }
 Future<void> _getAllNewTaskList() async{
    _getNewTaskListInProgress=true;
    setState(() {});
    final response = await NetWorkCaller.getRequest(Urls.newTaskList);
    if(response.isSuccess){
      _newTaskListWrapper=TaskListWrapper.fromJson(response.responseBody);
      _getNewTaskListInProgress=false;
      setState(() {

      });
    }else{
      _getNewTaskListInProgress=false;
      setState(() {

      });
      if(mounted){
        showSnackBarMessage(context, response.errorMessage?? 'Get new task list has been failed');
      }

    }
 }

 Future<void> _deleteTaskById(String id ) async{
    _deleteTaskListInProgress=true;
    setState(() {

    });
    final response = await NetWorkCaller.getRequest(Urls.deleteTask(id));
    _deleteTaskListInProgress=false;
    if(response.isSuccess){
      _getDataFromApis();
    }else{

      setState(() {

      });
      if(mounted){
        showSnackBarMessage(context, response.errorMessage?? 'Delete task has been failed');
      }
    }
 }


 Future<void> _updateTaskById(String id, String status) async {
_updateTaskStatusInProgress=true;
setState(() {

});
final response = await NetWorkCaller.getRequest(Urls.updateTaskStatus(id, status));
_updateTaskStatusInProgress = false;
if(response.isSuccess){
_getDataFromApis();
}else{

  setState(() {

  });
  if(mounted){
    showSnackBarMessage(context, response.errorMessage?? 'Update task status has been failed');
  }
}
 }
}




