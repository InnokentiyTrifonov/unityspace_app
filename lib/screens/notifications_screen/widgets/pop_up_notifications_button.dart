import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unityspace/screens/notifications_screen/notifications_screen.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/utils/localization_helper.dart';

class PopUpNotificationsButton extends StatelessWidget {
  const PopUpNotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = LocalizationHelper.getLocalizations(context);
    final store = context.wstore<NotificationsScreenStore>();

    return PopupMenuButton<String>(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      child: SizedBox(
        height: 55,
        width: 55,
        child: SvgPicture.asset('assets/icons/settings.svg'),
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          if (store.selectedTab == NotificationsScreenTab.current) ...[
            _buildMenuItem(
              context,
              iconPath: 'assets/icons/notifications/visible.svg',
              text: localization.read_all,
              onTap: store.readAllNotifications,
            ),
            _buildMenuItem(
              context,
              iconPath: 'assets/icons/notifications/download_box_1.svg',
              text: localization.archive_all,
              onTap: store.archiveAllNotifications,
            ),
          ] else if (store.selectedTab == NotificationsScreenTab.archived) ...[
            _buildMenuItem(
              context,
              iconPath: 'assets/icons/notifications/recycle_bin_2.svg',
              text: localization.delete_all,
              onTap: store.deleteAllNotifications,
            ),
          ],
        ];
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    BuildContext context, {
    required String iconPath,
    required String text,
    required void Function() onTap,
  }) {
    return PopupMenuItem<String>(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: SvgPicture.asset(iconPath),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 16.41 / 14,
                color: Color.fromRGBO(77, 77, 77, 1)),
          ),
        ],
      ),
    );
  }
}