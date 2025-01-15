import 'package:farms_gate_marketplace/data_base/address_db.dart';
import 'package:farms_gate_marketplace/model/address_model.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  AddressDatabaseHelper dataBase = AddressDatabaseHelper();
  List<AddressModel> addressList = [];
  List<AddressModel> get _addressList => addressList;
  int get addressLength => addressList.length;

  // Add product to address list
  void addToAddress(AddressModel address, BuildContext context) async {
    _addressList.add(address);
    await dataBase.insertAddress(address);
    showCustomToast(
        context, 'Address added successfully', '', ToastType.success);

    notifyListeners();
  }

  // remove from address list
  void removeFromAddress(AddressModel address, BuildContext context) async {
    addressList.removeWhere((item) => item.id == address.id);
    await dataBase.deleteAddress(address.id!.toInt());
    notifyListeners();
  }

  Future<void> loadAddresses() async {
    final addresses = await dataBase.getAllAddress();
    addressList = addresses;
    notifyListeners();
  }

  void setDefaultAddress(int id) async {
    await dataBase.updateAddressDefault(id);
    await loadAddresses();
    notifyListeners();
  }

  void setAddress(List<AddressModel> items) {
    addressList = items;
    notifyListeners();
  }

  void fetchAddresses() async {
    final items = await dataBase.getAllAddress();
    setAddress(items);
    notifyListeners();
  }

  void fetchDefaultAddress() async {
    final items = await dataBase.getAllAddress();
    final defaultAddress = items.firstWhere(
      (address) => address.isDefault == true,
      orElse: () => AddressModel(
        address: '',
        city: '',
        email: '',
        firstname: '',
        lastname: '',
        phonenumber: '',
        state: '',
      ),
    );

    setAddress([defaultAddress]);
    notifyListeners();
  }
}
