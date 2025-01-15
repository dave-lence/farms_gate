import 'package:farms_gate_marketplace/model/order_model.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  List<MyOrderModel> _ongoingOrders = [];
  List<MyOrderModel> _cancelledOrders = [];
  final ProductRepo productRepo = ProductRepo();
  bool _wasPopped = false;

  bool get wasPopped => _wasPopped;

  bool _isLoading = false;

  List<MyOrderModel> get ongoingOrders => _ongoingOrders;
  List<MyOrderModel> get cancelledOrders => _cancelledOrders;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

   void setWasPopped(bool value) {
    _wasPopped = value;
    notifyListeners();
  }

  void addOrder(MyOrderModel order) {
    if (order.status == 'cancelled') {
      _cancelledOrders.add(order);
    } else {
      _ongoingOrders.add(order);
    }
    notifyListeners();
  }

  void removeOrder(MyOrderModel order) {
    if (order.status == 'cancelled') {
      _cancelledOrders.remove(order);
    } else {
      _ongoingOrders.remove(order);
    }
    notifyListeners();
  }

  Future<void> fetchOrders(BuildContext context) async {
     if (_wasPopped) {
      setWasPopped(false); 
      return;
    }
    setLoading(true);
    try {
      final ongoing = await productRepo.getOrderedProducts(context, '');
      final cancelled =
          await productRepo.getOrderedProducts(context, 'cancelled');

      _ongoingOrders = ongoing;
      _cancelledOrders = cancelled;

      notifyListeners();
    } catch (e) {
    } finally {
      setLoading(false);
    }
  }
}
