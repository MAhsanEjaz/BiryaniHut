
import 'package:flutter/cupertino.dart';

import '../models/cart_model.dart';

class CartCounterProvider extends ChangeNotifier{

  int count=0;
  incrementCount(){
    count=count+1;
    notifyListeners();
  }

  setCount(int newCount){
    count=newCount;
    notifyListeners();
  }
  decrementCount(){
    count=count-1;
    notifyListeners();
  }
}