import 'dart:convert';

import 'package:unityspace/models/project_models.dart';
import 'package:unityspace/service/service_exceptions.dart';
import 'package:unityspace/utils/http_plugin.dart';

Future<List<ProjectResponse>> getProjects({required int spaceId}) async {
  try {
    final response = await HttpPlugin().get('/spaces/$spaceId/projects');
    final jsonDataList = json.decode(response.body) as List<dynamic>;
    final result =
        jsonDataList.map((data) => ProjectResponse.fromJson(data)).toList();
    return result;
  } catch (e) {
    if (e is HttpPluginException) {
      throw ServiceException(e.message);
    }
    rethrow;
  }
}

Future<List<ProjectResponse>> getAllProjects() async {
  try {
    final response = await HttpPlugin().get('/projects/all-projects');
    final jsonDataList = json.decode(response.body) as List<dynamic>;
    final result =
        jsonDataList.map((data) => ProjectResponse.fromJson(data)).toList();
    return result;
  } catch (e) {
    if (e is HttpPluginException) {
      throw ServiceException(e.message);
    }
    rethrow;
  }
}

/// Архивация и разархивация Проектов
Future<List<ProjectResponse>> changeProjectColumn(
    {required List<int> projectIds, required int columnId}) async {
  try {
    final response = await HttpPlugin()
        .patch('/projects/changeColumn/$columnId', {"projectIds": projectIds});
    final List jsonData = json.decode(response.body);
    return jsonData
        .map((element) => ProjectResponse.fromJson(element))
        .toList();
  } catch (e) {
    if (e is HttpPluginException) {
      throw ServiceException(e.message);
    }
    rethrow;
  }
}

Future<ProjectResponse> addProject(AddProject project) async {
  try {
    final response = await HttpPlugin().post('/projects', project.toJson());
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return ProjectResponse.fromJson(jsonData);
  } catch (e) {
    if (e is HttpPluginException) {
      throw ServiceException(e.message);
    }
    rethrow;
  }
}

Future<Map<String, dynamic>> deleteProject(int projectId) async {
  try {
    // приходит только статус и сообщение
    final response = await HttpPlugin().delete('/projects/$projectId');
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return jsonData;
  } catch (e) {
    if (e is HttpPluginException) {
      throw ServiceException(e.message);
    }
    rethrow;
  }
}
