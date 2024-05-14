class InitiatorAndRecipient {
  int id;
  int organizationId;
  String name;
  String? avatar;
  InitiatorAndRecipient({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.avatar,
  });
}

class PaginatedNotifications {
  final List<NotificationResponse> notifications;
  final int maxPagesCount;

  PaginatedNotifications(
      {required this.notifications, required this.maxPagesCount});

  factory PaginatedNotifications.fromJson(Map<String, dynamic> json) {
    var list = json['notifications'] as List;
    List<NotificationResponse> notificationsList =
        list.map((i) => NotificationResponse.fromJson(i)).toList();
    return PaginatedNotifications(
      notifications: notificationsList,
      maxPagesCount: json['maxPagesCount'] as int,
    );
  }
}

class NotificationResponse {
  final bool archived;
  final String createdAt;
  final int id;
  final int initiatorId;
  final List<NotificationLocation> locations;
  final int? message;
  final String notificationType;
  final int parentId;
  final String parentType;
  final int recipientId;
  final String? stageName;
  final String? taskName;
  final String text;
  final bool unread;

  NotificationResponse({
    required this.archived,
    required this.createdAt,
    required this.id,
    required this.initiatorId,
    required this.locations,
    required this.message,
    required this.notificationType,
    required this.parentId,
    required this.parentType,
    required this.recipientId,
    required this.stageName,
    required this.taskName,
    required this.text,
    required this.unread,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    var locList = json['locations'] as List;
    List<NotificationLocation> locationList =
        locList.map((i) => NotificationLocation.fromJson(i)).toList();
    return NotificationResponse(
      archived: json['archived'] as bool,
      createdAt: json['createdAt'] as String,
      id: json['id'] as int,
      initiatorId: json['initiatorId'] as int,
      locations: locationList,
      message: json['message'] as int?,
      notificationType: json['notificationType'] as String,
      parentId: json['parentId'] as int,
      parentType: json['parentType'] as String,
      recipientId: json['recipientId'] as int,
      stageName: json['stageName'] as String?,
      taskName: json['taskName'] as String?,
      text: json['text'] as String,
      unread: json['unread'] as bool,
    );
  }
}

class NotificationLocation {
  final int spaceId;
  final int? projectId;

  NotificationLocation({required this.spaceId, this.projectId});

  factory NotificationLocation.fromJson(Map<String, dynamic> json) {
    return NotificationLocation(
      spaceId: json['spaceId'] as int,
      projectId: json['projectId'] as int?,
    );
  }
}

class DeleteNotificationsResponse {
  int count;
  DeleteNotificationsResponse({
    required this.count,
  });
  factory DeleteNotificationsResponse.fromJson(Map<String, dynamic> map) {
    return DeleteNotificationsResponse(
      count: map['count'] as int,
    );
  }
}

class NotificationModel {
  final bool archived;
  final String createdAt;
  final int id;
  final int initiatorId;
  final List<NotificationLocation> locations;
  final int? message;
  final String notificationType;
  final int parentId;
  final String parentType;
  final int recipientId;
  final String? stageName;
  final String? taskName;
  final String text;
  final bool unread;

  NotificationModel({
    required this.archived,
    required this.createdAt,
    required this.id,
    required this.initiatorId,
    required this.locations,
    required this.message,
    required this.notificationType,
    required this.parentId,
    required this.parentType,
    required this.recipientId,
    required this.stageName,
    required this.taskName,
    required this.text,
    required this.unread,
  });

  factory NotificationModel.fromResponse(final NotificationResponse data) {
    return NotificationModel(
      archived: data.archived,
      createdAt: data.createdAt,
      id: data.id,
      initiatorId: data.initiatorId,
      locations: data.locations,
      message: data.message,
      notificationType: data.notificationType,
      parentId: data.parentId,
      parentType: data.parentType,
      recipientId: data.recipientId,
      stageName: data.stageName,
      taskName: data.taskName,
      text: data.text,
      unread: data.unread,
    );
  }
}
