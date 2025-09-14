import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/views/TaskListScreen/controller/task_cubit.dart';
import 'package:todo/views/TaskListScreen/view/task_add_screen.dart';
import 'package:todo/views/TaskListScreen/view/task_list_screen.dart';

import 'constants/app_themes.dart';
import 'controller/theme_cubit.dart';
import 'controller/theme_state.dart';
import 'data/local/task_model_hive.dart';
import 'data/network/repo/repository.dart';
import 'helper/init.dart';
import 'helper/route_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskHiveModelAdapter());

  final taskBox = await Hive.openBox<TaskHiveModel>('tasksBox');
  final pendingBox = await Hive.openBox('pendingBox');
  final settingsBox = await Hive.openBox('settingsBox');

  setupServiceLocator();

  runApp(MyApp(taskBox: taskBox,pendingBox: pendingBox,settingsBox: settingsBox,));
}

class MyApp extends StatelessWidget {
  final Box<TaskHiveModel> taskBox;
  final Box pendingBox;
  final settingsBox ;

  const MyApp({super.key, required this.taskBox, required this.pendingBox, this.settingsBox});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(settingsBox),
        ),
        BlocProvider<TaskCubit>(
          create: (_) => TaskCubit(
            GetIt.instance<AuthRepository>(),
            taskBox,
            pendingBox,
          )..fetchTasks(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: state.themeMode,
            initialRoute: RouteHelper.getInitialRoute(),
            routes: {
              RouteHelper.taskListScreen: (context) => const TaskListScreen(),
              RouteHelper.taskAddScreen: (context) => const TaskAddScreen(),
            },
          );
        },
      ),

    );
  }
}


