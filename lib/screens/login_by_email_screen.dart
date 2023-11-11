import 'package:flutter/material.dart';
import 'package:unityspace/utils/wstore_plugin.dart';
import 'package:unityspace/screens/widgets/main_form_input_field.dart';
import 'package:unityspace/screens/widgets/main_form_logo_widget.dart';
import 'package:unityspace/screens/widgets/main_form_text_button_widget.dart';
import 'package:unityspace/screens/widgets/main_form_text_title_widget.dart';
import 'package:unityspace/screens/widgets/main_form_widget.dart';
import 'package:unityspace/store/auth_store.dart';
import 'package:wstore/wstore.dart';

class LoginByEmailScreenStore extends WStore {
  WStoreStatus status = WStoreStatus.init;
  bool showPassword = false;
  String loginError = '';
  String email = '';
  String password = '';

  void toggleShowPassword() {
    setStore(() {
      showPassword = !showPassword;
    });
  }

  void login() {
    if (status == WStoreStatus.loading) return;
    //
    setStore(() {
      status = WStoreStatus.loading;
    });
    //
    subscribe(
      future: AuthStore().login(email, password),
      subscriptionId: 1,
      onData: (_) {
        setStore(() {
          status = WStoreStatus.loaded;
        });
      },
      onError: (error, __) {
        String errorText =
            'При входе возникла проблема, пожалуйста, попробуйте ещё раз';
        if (error == 'Incorrect user name or password') {
          errorText = 'Неправильный email или пароль!';
        }
        setStore(() {
          status = WStoreStatus.error;
          loginError = errorText;
        });
      },
    );
  }

  @override
  LoginByEmailScreen get widget => super.widget as LoginByEmailScreen;
}

class LoginByEmailScreen extends WStoreWidget<LoginByEmailScreenStore> {
  const LoginByEmailScreen({
    super.key,
  });

  @override
  LoginByEmailScreenStore createWStore() => LoginByEmailScreenStore();

  @override
  Widget build(BuildContext context, LoginByEmailScreenStore store) {
    return Scaffold(
      backgroundColor: const Color(0xFF111012),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const MainFormLogoWidget(),
              const SizedBox(height: 32),
              const MainFormTextTitleWidget(text: 'Войти по емайл'),
              const SizedBox(height: 32),
              Expanded(
                child: WStoreStatusBuilder(
                  store: store,
                  watch: (store) => store.status,
                  builder: (context) {
                    final loading = store.status == WStoreStatus.loading;
                    return LoginByEmailForm(loading: loading);
                  },
                  onStatusError: (context) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(store.loginError),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginByEmailForm extends StatelessWidget {
  final bool loading;

  const LoginByEmailForm({
    super.key,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return MainFormWidget(
      additionalButtonText: 'Другой способ входа',
      onAdditionalButton: () {
        Navigator.of(context).pop();
      },
      submitButtonText: 'Войти',
      onSubmit: () {
        FocusScope.of(context).unfocus();
        // загрузка и вход
        context.wstore<LoginByEmailScreenStore>().login();
      },
      submittingNow: loading,
      children: (submit) => [
        MainFormInputField(
          enabled: !loading,
          autofocus: true,
          labelText: 'Ваша электронная почта',
          iconAssetName: 'assets/icons/email.svg',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          validator: (text) {
            if (text.isEmpty) return 'Поле не заполнено';
            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(text)) {
              return 'Введите корректный email';
            }
            return '';
          },
          onSaved: (value) {
            context.wstore<LoginByEmailScreenStore>().email = value;
          },
        ),
        const SizedBox(height: 12),
        WStoreValueBuilder<LoginByEmailScreenStore, bool>(
          watch: (store) => store.showPassword,
          builder: (context, showPassword) {
            return MainFormInputField(
              enabled: !loading,
              labelText: 'Ваш пароль (не менее 8 символов)',
              iconAssetName: showPassword
                  ? 'assets/icons/password_hide.svg'
                  : 'assets/icons/password_show.svg',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !showPassword,
              autocorrect: false,
              enableSuggestions: false,
              onIconTap: () {
                context.wstore<LoginByEmailScreenStore>().toggleShowPassword();
              },
              onEditingComplete: () {
                submit();
              },
              validator: (text) {
                if (text.isEmpty) return 'Поле не заполнено';
                if (text.length < 8) {
                  return 'Пароль должен быть не менее 8 символов';
                }
                return '';
              },
              onSaved: (value) {
                context.wstore<LoginByEmailScreenStore>().password = value;
              },
            );
          },
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: MainFormTextButtonWidget(
            text: 'Забыли пароль?',
            onPressed: () {
              Navigator.pushNamed(context, '/restore');
            },
          ),
        ),
      ],
    );
  }
}
