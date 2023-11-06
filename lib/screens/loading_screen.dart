import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unityspace/plugins/logger_plugin.dart';
import 'package:unityspace/plugins/wstore_plugin.dart';
import 'package:unityspace/store/user_store.dart';
import 'package:unityspace/widgets/color_button_widget.dart';
import 'package:wstore/wstore.dart';

class LoadingScreenStore extends WStore {
  WStoreStatus status = WStoreStatus.init;
  String error = '';

  void loadData() {
    if (status == WStoreStatus.loading) return;
    //
    setStore(() {
      status = WStoreStatus.loading;
      error = '';
    });
    //
    subscribe(
      subscriptionId: 1,
      debounceDuration: const Duration(milliseconds: 1500),
      future: Future.wait([
        UserStore().getUserData(),
        UserStore().getOrganizationData(),
      ]),
      onData: (_) {
        setStore(() {
          status = WStoreStatus.loaded;
        });
      },
      onError: (e, stack) {
        logger.d('LoadingScreenStore loadData error=$e\nstack=$stack');
        String errorText =
            'При загрузке данных возникла проблема, пожалуйста, попробуйте ещё раз';
        setStore(() {
          status = WStoreStatus.error;
          error = errorText;
        });
      },
    );
  }

  @override
  LoadingScreen get widget => super.widget as LoadingScreen;
}

class LoadingScreen extends WStoreWidget<LoadingScreenStore> {
  const LoadingScreen({
    super.key,
  });

  @override
  LoadingScreenStore createWStore() => LoadingScreenStore()..loadData();

  @override
  Widget build(BuildContext context, LoadingScreenStore store) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Center(
          child: WStoreStatusBuilder(
            store: store,
            watch: (store) => store.status,
            builderError: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      store.error,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF111012).withOpacity(0.8),
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ColorButtonWidget(
                      width: double.infinity,
                      onPressed: () {
                        store.loadData();
                      },
                      text: 'Повтор',
                      loading: false,
                      colorBackground: const Color(0xFF111012),
                      colorText: Colors.white.withOpacity(0.9),
                    ),
                  ],
                ),
              );
            },
            builderLoading: (context) {
              return Lottie.asset(
                'assets/animations/main_loader.json',
                width: 200,
                height: 200,
              );
            },
            builder: (context) {
              return const SizedBox.shrink();
            },
            onStatusLoaded: (context) {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
        ),
      ),
    );
  }
}
