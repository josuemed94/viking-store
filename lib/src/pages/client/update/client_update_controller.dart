import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:app_ventas_ropa/src/models/response_api.dart';
import 'package:app_ventas_ropa/src/models/user.dart';
import 'package:app_ventas_ropa/src/provider/users_provider.dart';
import 'package:app_ventas_ropa/src/utils/my_snackbar.dart';
import 'package:app_ventas_ropa/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientUpdateController {

  BuildContext context;
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnamelController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  UserProvider userProvider = new UserProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh)async{
    this.context = context;
    this.refresh = refresh;

    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));

    print('TOKEN ENVIADO: ${user.sessionToken}');
    userProvider.init(context, sessionUser: user);

    nameController.text = user.name;
    lastnamelController.text = user.lastname;
    phoneController.text = user.phone;
    refresh();
  }

  void update() async{

    String name = nameController.text;
    String lastname = lastnamelController.text;
    String phone = phoneController.text.trim();


    if( name.isEmpty || lastname.isEmpty || phone.isEmpty ){
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    isEnable = false;

    User myUser = new User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        image: user.image
    );

    Stream stream = await userProvider.update(myUser, imageFile);
    stream.listen((res) async{

      _progressDialog.close();

      //ResponseApi responseApi = await userProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message);

      if (responseApi.success) {
        user = await userProvider.getById(myUser.id); // OBTENIEWDO EL USUARIO DE LA BASE DE DATOS
        print('Usuario obtenido: ${user.toJson()}');
        _sharedPref.save('user', user.toJson());

        Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
      }
      else {
        isEnable = true;
      }
    });
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if( pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  void back(){
    Navigator.pop(context);
  }

}
