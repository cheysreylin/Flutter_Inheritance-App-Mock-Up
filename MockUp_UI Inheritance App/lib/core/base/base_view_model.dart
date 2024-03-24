import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier{
  late bool disposed;

  BaseViewModel(){
    disposed = false;
  }

  @override
  void notifyListeners(){
    if(disposed) return;
    super.notifyListeners();
  }

  @override
  void dispose(){
    disposed = true;
    super.dispose();
  }
}
