import 'package:unityspace/utils/helpers.dart' as helpers;

class UserResponse {
  final int id;
  final int globalId;
  final String name;
  final String email;
  final String? avatar;
  final String? phoneNumber;
  final String? telegramLink;
  final String? githubLink;
  final String? birthDate;
  final String? jobTitle;

  const UserResponse({
    required this.id,
    required this.globalId,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phoneNumber,
    required this.telegramLink,
    required this.githubLink,
    required this.birthDate,
    required this.jobTitle,
  });

  factory UserResponse.fromJson(Map<String, dynamic> map) {
    return UserResponse(
      id: map['id'] as int,
      globalId: map['globalId'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      telegramLink: map['telegramLink'] as String?,
      githubLink: map['githubLink'] as String?,
      birthDate: map['birthDate'] as String?,
      jobTitle: map['jobTitle'] as String?,
    );
  }
}

class User {
  final int id;
  final int globalId;
  final String name;
  final String email;
  final String? avatarLink;
  final String? phoneNumber;
  final String? telegramLink;
  final String? githubLink;
  final DateTime? birthDate;
  final String? jobTitle;

  const User({
    required this.id,
    required this.globalId,
    required this.name,
    required this.email,
    required this.avatarLink,
    required this.phoneNumber,
    required this.telegramLink,
    required this.githubLink,
    required this.birthDate,
    required this.jobTitle,
  });

  factory User.fromResponse(final UserResponse data) {
    return User(
      id: data.id,
      globalId: data.globalId,
      name: data.name,
      email: data.email,
      avatarLink: helpers.makeAvatarUrl(data.avatar),
      phoneNumber: helpers.getNullStringIfEmpty(data.phoneNumber),
      telegramLink: helpers.getNullStringIfEmpty(data.telegramLink),
      githubLink: helpers.getNullStringIfEmpty(data.githubLink),
      birthDate:
          data.birthDate != null ? DateTime.parse(data.birthDate!) : null,
      jobTitle: helpers.getNullStringIfEmpty(data.jobTitle),
    );
  }

  @override
  String toString() {
    return 'User{id: $id, globalId: $globalId, name: $name, email: $email, avatarLink: $avatarLink, phoneNumber: $phoneNumber, telegramLink: $telegramLink, githubLink: $githubLink, birthDate: $birthDate, jobTitle: $jobTitle}';
  }
}

class OrganizationResponse {
  final int id;
  final int ownerId;
  final String createdAt;
  final String updatedAt;
  final int availableUsersCount;
  final String? licenseEndDate;
  final String? trialEndDate;
  final List<OrganizationMemberResponse> members;
  final int uniqueSpaceUsersCount;

  OrganizationResponse({
    required this.id,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    required this.availableUsersCount,
    required this.licenseEndDate,
    required this.trialEndDate,
    required this.members,
    required this.uniqueSpaceUsersCount,
  });

  factory OrganizationResponse.fromJson(Map<String, dynamic> map) {
    final membersList = map['members'] as List<dynamic>;
    return OrganizationResponse(
      id: map['id'] as int,
      ownerId: map['ownerId'] as int,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      availableUsersCount: map['availableUsersCount'] as int,
      licenseEndDate: map['licenseEndDate'] as String?,
      trialEndDate: map['trialEndDate'] as String?,
      members: membersList
          .map((member) => OrganizationMemberResponse.fromJson(member))
          .toList(),
      uniqueSpaceUsersCount: map['uniqueSpaceUsersCount'] as int,
    );
  }
}

class OrganizationMemberResponse {
  final String? avatar;
  final String email;
  final String name;
  final int organizationId;
  final int id;
  final List<UserAchievementsResponse> userAchievements;
  final String? phoneNumber;
  final String? telegramLink;
  final String? githubLink;
  final String? birthDate;
  final String? jobTitle;
  final String lastActivityDate;

  OrganizationMemberResponse({
    required this.avatar,
    required this.email,
    required this.name,
    required this.organizationId,
    required this.id,
    required this.userAchievements,
    required this.phoneNumber,
    required this.telegramLink,
    required this.githubLink,
    required this.birthDate,
    required this.jobTitle,
    required this.lastActivityDate,
  });

  factory OrganizationMemberResponse.fromJson(Map<String, dynamic> map) {
    final userAchievementsList = map['userAchievements'] as List<dynamic>;
    return OrganizationMemberResponse(
      avatar: map['avatar'] as String?,
      email: map['email'] as String,
      name: map['name'] as String,
      organizationId: map['organizationId'] as int,
      id: map['id'] as int,
      userAchievements: userAchievementsList
          .map((member) => UserAchievementsResponse.fromJson(member))
          .toList(),
      phoneNumber: map['phoneNumber'] as String?,
      telegramLink: map['telegramLink'] as String?,
      githubLink: map['githubLink'] as String?,
      birthDate: map['birthDate'] as String?,
      jobTitle: map['jobTitle'] as String?,
      lastActivityDate: map['lastActivityDate'] as String,
    );
  }
}

class UserAchievementsResponse {
  final int userId;
  final String achievementType;
  final String dateReceived;

  UserAchievementsResponse({
    required this.userId,
    required this.achievementType,
    required this.dateReceived,
  });

  factory UserAchievementsResponse.fromJson(Map<String, dynamic> map) {
    return UserAchievementsResponse(
      userId: map['userId'] as int,
      achievementType: map['achievementType'] as String,
      dateReceived: map['dateReceived'] as String,
    );
  }
}

class Organization {
  final int id;
  final int ownerId;
  final int availableUsersCount;
  final DateTime? licenseEndDate;
  final DateTime? trialEndDate;
  final List<OrganizationMember> members;
  final int uniqueSpaceUsersCount;

  Organization({
    required this.id,
    required this.ownerId,
    required this.availableUsersCount,
    required this.licenseEndDate,
    required this.trialEndDate,
    required this.members,
    required this.uniqueSpaceUsersCount,
  });

  factory Organization.fromResponse(final OrganizationResponse data) {
    return Organization(
      id: data.id,
      ownerId: data.ownerId,
      availableUsersCount: data.availableUsersCount,
      licenseEndDate: data.licenseEndDate != null
          ? DateTime.parse(data.licenseEndDate!)
          : null,
      trialEndDate:
          data.trialEndDate != null ? DateTime.parse(data.trialEndDate!) : null,
      members: data.members
          .map((memberData) => OrganizationMember.fromResponse(memberData))
          .toList(),
      uniqueSpaceUsersCount: data.uniqueSpaceUsersCount,
    );
  }

  @override
  String toString() {
    return 'Organization{id: $id, ownerId: $ownerId, availableUsersCount: $availableUsersCount, licenseEndDate: $licenseEndDate, trialEndDate: $trialEndDate, members: $members, uniqueSpaceUsersCount: $uniqueSpaceUsersCount}';
  }
}

class OrganizationMember {
  final int id;
  final String? avatarLink;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? telegramLink;
  final String? githubLink;
  final DateTime? birthDate;
  final String? jobTitle;

  OrganizationMember({
    required this.id,
    required this.avatarLink,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.telegramLink,
    required this.githubLink,
    required this.birthDate,
    required this.jobTitle,
  });

  factory OrganizationMember.fromResponse(
    final OrganizationMemberResponse data,
  ) {
    return OrganizationMember(
      id: data.id,
      email: data.email,
      name: data.name,
      phoneNumber: helpers.getNullStringIfEmpty(data.phoneNumber),
      telegramLink: helpers.getNullStringIfEmpty(data.telegramLink),
      githubLink: helpers.getNullStringIfEmpty(data.githubLink),
      jobTitle: helpers.getNullStringIfEmpty(data.jobTitle),
      avatarLink: helpers.makeAvatarUrl(data.avatar),
      birthDate:
          data.birthDate != null ? DateTime.parse(data.birthDate!) : null,
    );
  }

  factory OrganizationMember.fromUser(final User data) {
    return OrganizationMember(
      id: data.id,
      avatarLink: data.avatarLink,
      email: data.email,
      name: data.name,
      phoneNumber: data.phoneNumber,
      telegramLink: data.telegramLink,
      githubLink: data.githubLink,
      birthDate: data.birthDate,
      jobTitle: data.jobTitle,
    );
  }

  @override
  String toString() {
    return 'OrganizationMember{id: $id, avatarLink: $avatarLink, email: $email, name: $name, phoneNumber: $phoneNumber, telegramLink: $telegramLink, githubLink: $githubLink, birthDate: $birthDate jobTitle: $jobTitle}';
  }
}
