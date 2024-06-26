import 'package:flutter/material.dart';
import 'package:unityspace/models/project_models.dart';
import 'package:unityspace/models/spaces_models.dart';
import 'package:unityspace/resources/l10n/app_localizations.dart';
import 'package:unityspace/screens/widgets/app_dialog/app_dialog_dropdown_menu.dart';
import 'package:unityspace/screens/widgets/app_dialog/app_dialog_input_field.dart';
import 'package:unityspace/screens/widgets/app_dialog/app_dialog_with_buttons.dart';
import 'package:unityspace/store/projects_store.dart';
import 'package:unityspace/store/spaces_store.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/utils/localization_helper.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:wstore/wstore.dart';

Future<void> showProjectPropertiesDialog(
  BuildContext context,
  Project project,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return ProjectPropertiesDialog(
        project: project,
      );
    },
  );
}

class ProjectPropertiesDialogStore extends WStore {
  String projectPropertiesError = '';
  WStoreStatus statusProjectProperties = WStoreStatus.init;

  int? responsibleId;
  String name = '';
  int postponingTaskDayCount = 0;
  String? color;

  List<SpaceMember> get spaceMembers => computedFromStore(
        store: SpacesStore(),
        getValue: (store) =>
            store.spacesMap[widget.project.spaceId]?.members ?? [],
        keyName: 'spaceMembers',
      );

  String get responsibleName => computedFromStore(
        store: UserStore(),
        getValue: (store) =>
            store.organizationMembersMap[responsibleId]?.name ?? '???',
        keyName: 'responsibleName',
      );

  void setProjectName(String projectName) {
    setStore(() {
      name = projectName;
    });
  }

  void setProjectColor(String? projectColor) {
    setStore(() {
      color = projectColor;
    });
  }

  void setMarkAsSnail(int count) {
    setStore(() {
      postponingTaskDayCount = count;
    });
  }

  void setProjectResponsible(int? memberId) {
    setStore(() {
      responsibleId = memberId;
    });
  }

  void initData(Project project) {
    name = project.name;
    color = project.color;
    responsibleId = project.responsibleId;
    postponingTaskDayCount = project.postponingTaskDayCount;
  }

  void saveProjectProperties(AppLocalizations localization, int projectId) {
    if (statusProjectProperties == WStoreStatus.loading) return;
    setStore(() {
      statusProjectProperties = WStoreStatus.loading;
      projectPropertiesError = '';
    });

    subscribe(
      future: ProjectsStore().updateProject(
        id: projectId,
        name: name,
        color: color,
        responsibleId: responsibleId,
        postponingTaskDayCount: postponingTaskDayCount,
      ),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          statusProjectProperties = WStoreStatus.loaded;
        });
      },
      onError: (error, stack) {
        logger.d(
          'ProjectPropertiesDialogStore.projectProperties error: $error stack: $stack',
        );
        setStore(() {
          statusProjectProperties = WStoreStatus.error;
          projectPropertiesError = localization.save_project_properties_error;
        });
      },
    );
  }

  @override
  ProjectPropertiesDialog get widget => super.widget as ProjectPropertiesDialog;
}

class ProjectPropertiesDialog
    extends WStoreWidget<ProjectPropertiesDialogStore> {
  final Project project;

  const ProjectPropertiesDialog({
    required this.project,
    super.key,
  });

  @override
  ProjectPropertiesDialogStore createWStore() =>
      ProjectPropertiesDialogStore()..initData(project);

  @override
  Widget build(BuildContext context, ProjectPropertiesDialogStore store) {
    final localization = LocalizationHelper.getLocalizations(context);
    return WStoreStatusBuilder(
      store: store,
      watch: (store) => store.statusProjectProperties,
      onStatusLoaded: (context) {
        Navigator.of(context).pop();
      },
      builder: (context, status) {
        final loading = status == WStoreStatus.loading;
        final error = status == WStoreStatus.error;
        return AppDialogWithButtons(
          title: localization.change_project,
          primaryButtonText: localization.save,
          onPrimaryButtonPressed: () {
            FocusScope.of(context).unfocus();
            store.saveProjectProperties(localization, project.id);
          },
          primaryButtonLoading: loading,
          secondaryButtonText: '',
          children: [
            WStoreValueBuilder(
              store: store,
              watch: (store) => store.name,
              builder: (context, name) {
                return AddDialogInputField(
                  autofocus: true,
                  initialValue: name,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (projectName) {
                    store.setProjectName(projectName);
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  labelText: localization.project_name,
                );
              },
            ),
            const SizedBox(height: 16),
            WStoreValueBuilder(
              watch: (store) => store.color,
              store: store,
              builder: (context, color) {
                final defColors = [
                  '#D8EFF4',
                  '#F3E2D9',
                  '#F1DBF2',
                  '#D9DDF3',
                  '#E5F5DD',
                  '#CAECD8',
                  '#ECDECA',
                ];
                final List<(String?, String)> listProjectColors = [
                  (null, localization.color_is_empty),
                  ...defColors.map(
                    (color) => (color, getColorName(color, localization)),
                  ),
                  if (color != null && !defColors.contains(color))
                    (color, getColorName(color, localization)),
                ];
                return AddDialogDropdownMenu<String?>(
                  onChanged: (color) {
                    FocusScope.of(context).unfocus();
                    store.setProjectColor(color);
                  },
                  labelText: localization.color,
                  listValues: listProjectColors,
                  currentValue: color,
                );
              },
            ),
            const SizedBox(height: 16),
            WStoreBuilder(
              watch: (store) => [
                store.responsibleId,
                store.spaceMembers,
                store.responsibleName,
              ],
              store: store,
              builder: (context, store) {
                final List<(int?, String)> listMembers = [
                  (null, localization.without_responsible),
                  ...store.spaceMembers.map(
                    (member) => (member.id, member.name),
                  ),
                  if (store.responsibleId != null &&
                      store.spaceMembers.indexWhere(
                            (member) => member.id == store.responsibleId,
                          ) ==
                          -1)
                    (store.responsibleId, store.responsibleName),
                ];
                return AddDialogDropdownMenu<int?>(
                  onChanged: (memberId) {
                    FocusScope.of(context).unfocus();
                    store.setProjectResponsible(memberId);
                  },
                  labelText: localization.project_responsible,
                  listValues: listMembers,
                  currentValue: store.responsibleId,
                );
              },
            ),
            const SizedBox(height: 16),
            WStoreValueBuilder(
              watch: (store) => store.postponingTaskDayCount,
              store: store,
              builder: (context, postponingTaskDayCount) {
                final List<(int, String)> listValues = [
                  (0, localization.disabled),
                  (1, localization.days(1)),
                  (2, localization.days(2)),
                  (3, localization.days(3)),
                  (4, localization.days(4)),
                  (5, localization.days(5)),
                  (6, localization.days(6)),
                  (7, localization.days(7)),
                  if (postponingTaskDayCount < 0 || postponingTaskDayCount > 7)
                    (
                      postponingTaskDayCount,
                      localization.days(postponingTaskDayCount),
                    ),
                ];
                return AddDialogDropdownMenu<int>(
                  onChanged: (count) {
                    FocusScope.of(context).unfocus();
                    if (count != null) store.setMarkAsSnail(count);
                  },
                  labelText: localization.mark_tasks_as_snail,
                  listValues: listValues,
                  currentValue: postponingTaskDayCount,
                );
              },
            ),
            if (error)
              Text(
                store.projectPropertiesError,
                style: const TextStyle(
                  color: Color(0xFFD83400),
                ),
              ),
          ],
        );
      },
    );
  }
}
