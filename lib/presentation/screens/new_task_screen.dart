import 'package:flutter/material.dart';
import 'package:task_manager_app/presentation/data/models/count_by_status_wrapper.dart';
import 'package:task_manager_app/presentation/data/models/task_list_wrapper.dart';
import 'package:task_manager_app/presentation/data/services/network_caller.dart';
import 'package:task_manager_app/presentation/data/utility/urls.dart';
import 'package:task_manager_app/presentation/screens/add_new_task_screen.dart';
import 'package:task_manager_app/presentation/utils/app_colors.dart';
import 'package:task_manager_app/presentation/widgets/background_widget.dart';
import 'package:task_manager_app/presentation/widgets/snak_bar_message.dart';
import '../widgets/empty_list_widget.dart';
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
                visible: _getNewTaskListInProgress == false ,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _getDataFromApis();
                  },
                  child: Visibility(
                    visible: _newTaskListWrapper.taskList?.isNotEmpty?? false,
                    replacement: const EmptyListWidget(),
                    child: ListView.builder(
                      itemCount: _newTaskListWrapper.taskList?.length??0,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskItem: _newTaskListWrapper.taskList![index],
                          refreshList: (){
                            _getDataFromApis();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          ///todo: refresh home apis after successfully add new tasks
          final result =await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
          if(result!=null&& result==true){
            _getDataFromApis();
          }
        },
        backgroundColor: AppColors.themeColor,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
 Widget get taskCounterSection{
    return  SizedBox(
      height: 115,
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



}




