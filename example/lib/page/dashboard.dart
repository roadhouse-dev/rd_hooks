import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:rd_hooks/src/dialog_hook.dart';
import 'package:rd_hooks/src/use_app_lifecycle.dart';
import 'package:rd_hooks/src/use_internet_connectivity.dart';


//part 'dashboard.g.dart';

class Dashboard extends HookWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dialogController = useDialogController();

    useAppLifecycle((event) {
      if (event == LifecycleEvent.onResume) {
        Fimber.d("App onResume");
      }
    });

    useInternetConnectivity((result) {
      switch (result) {
        case ConnectivityResult.wifi:
          Fimber.d("Get connectivity - wifi");
          break;
        case ConnectivityResult.mobile:
          Fimber.d("Get connectivity - mobile");
          break;
        case ConnectivityResult.none:
          Fimber.d("No connectivity.");
          break;
        default:
          Fimber.d("Failed to get connectivity.");
          break;
      }
    });

    return Scaffold(
        appBar: AppBar(title: Text('RD Hooks')),
        body: Container(
          alignment: Alignment.center,
          child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Dialog'),
              color: Colors.blue,
              onPressed: () {
                dialogController.showAlertDialog(
                  title: Text('Title'),
                  content: Text('Content'),
                );
              },
            )
          ],

        ),));
  }
}