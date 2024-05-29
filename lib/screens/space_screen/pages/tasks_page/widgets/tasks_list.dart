import 'package:flutter/material.dart';
import 'package:unityspace/models/task_models.dart';
import 'package:unityspace/screens/space_screen/pages/tasks_page/tasks_page.dart';
import 'package:unityspace/screens/space_screen/pages/tasks_page/widgets/divider.dart';
import 'package:unityspace/screens/widgets/common/paddings.dart';
import 'package:unityspace/src/theme/theme.dart';
import 'package:wstore/wstore.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    required this.tasksList,
    super.key,
  });

  final List<TasksGroup> tasksList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasksList.length,
      itemBuilder: (context, projectIndex) {
        final tasks = tasksList[projectIndex].tasks;
        return ProjectGroup(
          tasksList: tasksList,
          tasks: tasks,
          projectIndex: projectIndex,
        );
      },
    );
  }
}

class ProjectGroupStore extends WStore {
  bool isListVisible = true;

  void toggleVisibility() {
    setStore(() {
      isListVisible = !isListVisible;
    });
  }

  @override
  ProjectGroup get widget => super.widget as ProjectGroup;
}

class ProjectGroup extends WStoreWidget<ProjectGroupStore> {
  const ProjectGroup({
    required this.tasksList,
    required this.tasks,
    required this.projectIndex,
    super.key,
  });

  final List<TasksGroup> tasksList;
  final List<Task> tasks;
  final int projectIndex;

  @override
  ProjectGroupStore createWStore() => ProjectGroupStore();

  @override
  Widget build(BuildContext context, ProjectGroupStore store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            store.toggleVisibility();
          },
          child: Row(
            children: [
              WStoreValueBuilder<ProjectGroupStore, bool>(
                watch: (store) => store.isListVisible,
                builder: (context, store) {
                  return store
                      ? const Icon(Icons.arrow_downward)
                      : const Icon(Icons.arrow_forward);
                },
              ),
              const PaddingLeft(20),
              Flexible(
                child: Text(
                  tasksList[projectIndex].groupTitle,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const PaddingTop(8),
        WStoreValueBuilder<ProjectGroupStore, bool>(
          watch: (store) => store.isListVisible,
          builder: (context, store) {
            return PaddingVertical(
              16,
              child: Visibility(
                maintainState: true,
                visible: store,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, taskIndex) {
                    return IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: PaddingLeft(
                              16,
                              child: Text(
                                tasks[taskIndex].name,
                              ),
                            ),
                          ),
                          const DividerWithoutPadding(
                            isHorisontal: false,
                            color: ColorConstants.grey04,
                          ),
                          Expanded(
                            flex: 2,
                            child: PaddingLeft(
                              8,
                              child: PaddingBottom(
                                8,
                                child: Text(
                                  context
                                          .wstore<TasksPageStore>()
                                          .getProjectNameById(
                                            tasks[taskIndex]
                                                // не знаю какую брать и могут ли они вообще
                                                // отличаться
                                                .stages[0]
                                                .projectId,
                                          ) ??
                                      // не локализовано потому что
                                      // placeholder, потом нужно будет узнать что
                                      // делать если у задачи нет проекта
                                      'Проект не существует',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
