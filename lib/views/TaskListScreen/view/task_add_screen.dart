import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/views/TaskListScreen/controller/task_cubit.dart';
import 'package:todo/views/TaskListScreen/controller/task_state.dart';
import 'package:todo/views/TaskListScreen/model/task_model.dart';

import 'dart:math';

import '../../../widgets/custom_textfield.dart';

class TaskAddScreen extends StatelessWidget {
  const TaskAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskLoaded) {
              // Task added successfully
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task added successfully')),
              );

              // Pop back to previous screen
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            } else if (state is TaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                CustomTextField(
                  controller: titleController,
                  labelText: 'Title',
                  hintText: 'Enter task title',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: descriptionController,
                  labelText: 'Description',
                  hintText: 'Enter task description',
                  maxLines: 4,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state is TaskLoading
                        ? null
                        : () {
                      final title = titleController.text.trim();
                      final description = descriptionController.text.trim();

                      if (title.isEmpty || description.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all fields')),
                        );
                        return;
                      }

                      // Create TaskModel
                      final task = TaskModel(
                        id: Random().nextInt(1000000),
                        todo: title,
                        completed: false,
                        userId: 1,
                      );

                      // Call cubit to add task
                      context.read<TaskCubit>().addTask(task);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is TaskLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Add Task',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
