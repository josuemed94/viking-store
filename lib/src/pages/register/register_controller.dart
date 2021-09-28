import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:app_ventas_ropa/src/models/response_api.dart';
import 'package:app_ventas_ropa/src/models/user.dart';
import 'package:app_ventas_ropa/src/provider/users_provider.dart';
import 'package:app_ventas_ropa/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController {

  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnamelController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  UserProvider userProvider = new UserProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    userProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  void register() async{
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnamelController.text;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if(email.isEmpty || name.isEmpty || lastname.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return;
    }

    if (confirmPassword != password){
      MySnackbar.show(context, 'Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6){
      MySnackbar.show(context, 'Las contraseñas debe tener al menos 6 caracteres');
      return;
    }

    if (imageFile == null) {
      MySnackbar.show(context, 'Selecciona una imagen');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    isEnable = false;

    User user = new User(
      email: email,
      name: name,
      lastname: lastname,
      phone: phone,
      password: password
    );

    Stream stream = await userProvider.createWithImage(user, imageFile);
    stream.listen((res) {

      _progressDialog.close();

      //ResponseApi responseApi = await userProvider.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print('RESPUESTA: ${responseApi.toJson()}');

      MySnackbar.show(context, responseApi.message);

      if (responseApi.success) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, 'login');
        });
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
