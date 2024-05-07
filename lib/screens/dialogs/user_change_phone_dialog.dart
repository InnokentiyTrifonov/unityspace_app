import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:unityspace/screens/widgets/app_dialog/app_dialog_input_field.dart';
import 'package:unityspace/screens/widgets/app_dialog/app_dialog_with_buttons.dart';

import 'package:flutter/material.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/utils/logger_plugin.dart';
import 'package:wstore/wstore.dart';
import 'package:unityspace/utils/localization_helper.dart';

Future<void> showUserChangePhoneDialog(
  BuildContext context,
  final String phone,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return UserChangePhoneDialog(phone: phone);
    },
  );
}

class UserChangePhoneDialogStore extends WStore {
  String phone = '';
  String changeError = '';
  bool phoneValid = true;
  WStoreStatus statusChange = WStoreStatus.init;

  void setPhone(String value) {
    setStore(() {
      phone = value;
    });
    if (validatePhone(value)) {
      setStore(() {
        phoneValid = true;
        statusChange = WStoreStatus.init;
        changeError = '';
      });
    } else {
      setStore(() {
        phoneValid = false;
        statusChange = WStoreStatus.error;
        changeError = 'Введите корректный номер телефона';
      });
    }
  }

  bool validatePhone(String value) {
    if (value.isEmpty) return true;
    if (value.contains(RegExp(r'[^0-9\\+]'))) return false;
    final phone = PhoneNumber.parse(value);
    if (phone.isValid(type: PhoneNumberType.mobile)) {
      return true;
    }
    return false;
  }

  void changePhone() {
    if (statusChange == WStoreStatus.loading) return;
    //
    setStore(() {
      statusChange = WStoreStatus.loading;
      changeError = '';
    });
    //
    if (phone == widget.phone) {
      setStore(() {
        statusChange = WStoreStatus.loaded;
      });
      return;
    }
    //
    subscribe(
      future: UserStore().setPhone(phone),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          statusChange = WStoreStatus.loaded;
        });
      },
      onError: (error, stack) {
        String errorText =
            'При смене номера телефона возникла проблема, пожалуйста, попробуйте ещё раз';
        logger.d(
            'UserChangePhoneDialogStore.changePhone error: $error stack: $stack');
        setStore(() {
          statusChange = WStoreStatus.error;
          changeError = errorText;
        });
      },
    );
  }

  @override
  UserChangePhoneDialog get widget => super.widget as UserChangePhoneDialog;
}

class UserChangePhoneDialog extends WStoreWidget<UserChangePhoneDialogStore> {
  final String phone;

  const UserChangePhoneDialog({
    super.key,
    required this.phone,
  });

  @override
  UserChangePhoneDialogStore createWStore() =>
      UserChangePhoneDialogStore()..phone = phone;

  @override
  Widget build(BuildContext context, UserChangePhoneDialogStore store) {
    final localization = LocalizationHelper.getLocalizations(context);
    return WStoreStatusBuilder(
      store: store,
      watch: (store) => store.statusChange,
      onStatusLoaded: (context) {
        Navigator.of(context).pop();
      },
      builder: (context, status) {
        final loading = status == WStoreStatus.loading;
        final error = status == WStoreStatus.error;
        return AppDialogWithButtons(
          title: localization.change_phone_number,
          primaryButtonText: localization.save,
          onPrimaryButtonPressed: store.phoneValid
              ? () {
                  FocusScope.of(context).unfocus();
                  store.changePhone();
                }
              : null,
          primaryButtonLoading: loading,
          secondaryButtonText: '',
          children: [
            AddDialogInputField(
              autofocus: true,
              initialValue: phone,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                store.setPhone(value);
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                store.changePhone();
              },
              labelText: localization.enter_phone_number,
            ),
            const SizedBox(height: 8),
            Text(
              '${localization.phone_number_must_start_from_country_code} '
              '(${localization.example_number_phone})',
            ),
            if (error)
              Text(
                store.changeError,
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
