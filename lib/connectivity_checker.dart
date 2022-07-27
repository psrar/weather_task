import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

//Если интернет недоступен, эта функция отобразит SnackBar
//Иначе выполнит action
Future executeOrShowSnackBar(BuildContext context, Function action) async {
  await Connectivity().checkConnectivity().then((value) {
    if (value == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Отсутствует подключение к интернету'),
        ),
      );
    } else {
      action();
    }
  });
}
