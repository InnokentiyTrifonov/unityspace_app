import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unityspace/models/user_models.dart';
import 'package:unityspace/resources/app_icons.dart';
import 'package:unityspace/screens/administration_screen/helpers/organization_role_enum.dart';
import 'package:unityspace/screens/administration_screen/pages/users_in_organization_page.dart';
import 'package:unityspace/screens/widgets/user_avatar_widget.dart';
import 'package:unityspace/utils/extensions/localization_extensions.dart';
import 'package:unityspace/utils/localization_helper.dart';
import 'package:wstore/wstore.dart';

class UserInOrganizationInfoCard extends StatelessWidget {
  final OrganizationMember organizationMember;
  final OrganizationRoleEnum role;

  const UserInOrganizationInfoCard({
    required this.organizationMember,
    required this.role,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationHelper.getLocalizations(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: UserAvatarWidget(
                      id: organizationMember.id,
                      width: 30,
                      height: 30,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          organizationMember.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          organizationMember.email,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          context
                              .wstore<UsersInOrganizationPageStore>()
                              .getMemberSpaces(organizationMember.id),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          role.localize(localization: localization),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (context
                      .wstore<UsersInOrganizationPageStore>()
                      .hasMemberEditingRights(role))
                    const SizedBox(
                      height: 30,
                      width: 30,
                    )
                  else
                    PopupMenuButton<String>(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.white,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(AppIcons.settings),
                      ),
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            child: Text(localization.delete),
                            onTap: () {
                              context
                                  .wstore<UsersInOrganizationPageStore>()
                                  .deleteMember(organizationMember);
                            },
                          ),
                          PopupMenuItem<String>(
                            child: Text(
                              role == OrganizationRoleEnum.admin
                                  ? localization.remove_administrator_rights
                                  : localization.grant_administrator_rights,
                            ),
                            onTap: () {
                              context
                                  .wstore<UsersInOrganizationPageStore>()
                                  .setMemberAdmin(
                                    organizationMember,
                                    role != OrganizationRoleEnum.admin,
                                  );
                            },
                          ),
                        ];
                      },
                    ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
