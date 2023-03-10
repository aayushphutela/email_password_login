import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/models/user_model.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/tempFile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameEditingcontroller = new TextEditingController();
  final emailEditingcontroller = new TextEditingController();
  final passwordEditingcontroller = new TextEditingController();
  final mobileEditingcontroller = new TextEditingController();
  final collegeEditingcontroller = new TextEditingController();
  final admissionYearEditingcontroller = new TextEditingController();
  final passOutYearEditingcontroller = new TextEditingController();
  final profilePicEditingcontroller = new TextEditingController();
  final resumeEditingcontroller = new TextEditingController();
  var selectedYear;
  var sequenceNumbers = new List<int>.generate(24, (k) => k + 2000);
  String? usertypeValue;
  File? imgFile;
  final imgPicker = ImagePicker();
  var uploadImageResult;

  //FireBase
  final _auth = FirebaseAuth.instance;

  // List of items in our dropdown menu

  List<Map> _myJson = [
    {"id": 1, "name": "Student"},
    {"id": 2, "name": "Almuni"},
    {"id": 3, "name": "Faculty"},
  ];

  XFile? _image;
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    final imageTypeFeild = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ImageFromGalleryEx(ImageSourceType.camera, (image, imgUrl) {
          _image = image;
          imageUrl = imgUrl;
          setState(() {});
        }),
        ImageFromGalleryEx(ImageSourceType.gallery, (image, imgUrl) {
          _image = image;
          imageUrl = imgUrl;
          setState(() {});
        }),
      ],
    );
    // ImageHere();
    final userTypeFeild = Container(
      // height: 60,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        // color: AppColorTheme.lightGreyColor,
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          isExpanded: false,
          hint: Text('User Type'),
          // style: AppTextTheme.textFields(14, true),
          isDense: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Select your choice';
            }
            return null;
          },

          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
            filled: true,
            // fillColor: AppColorTheme.lightGreyColor,
          ),
          // dropdownColor: AppColorTheme.lightGreyColor,
          value: usertypeValue,
          onChanged: (String? newValue) {
            setState(() {
              usertypeValue = newValue;

              print("PRINT VALUE=== $usertypeValue");
            });
            print(usertypeValue);
          },
          items: _myJson.map((Map map) {
            return new DropdownMenuItem<String>(
              value: map["name"].toString(),
              child: new Text(
                map["name"],
              ),
            );
          }).toList(),
        ),
      ),
    );
    final emailField = TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      autofocus: false,
      controller: emailEditingcontroller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }

        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
    );
    final passwordFeild = TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      autofocus: false,
      controller: passwordEditingcontroller,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
    );
    final nameFeild = TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.abc),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      autofocus: false,
      controller: nameEditingcontroller,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Name Is Required");
        }
      },
      onSaved: (value) {
        nameEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
    );
    final mobileFeild = TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      autofocus: false,
      controller: mobileEditingcontroller,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      validator: (value) {
        RegExp regex = new RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          return ("Phone Number Is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Phone Number");
        }
      },
      // onSaved: (value) {
      //   mobileEditingcontroller.text = value!;
      // },
      textInputAction: TextInputAction.next,
    );
    final collegeNameFeild = TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.villa),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "College name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      autofocus: false,
      controller: collegeEditingcontroller,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("College Name Is Required");
        }
      },
      onSaved: (value) {
        collegeEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final admissionYear = Column(
      children: [
        DropdownButtonFormField<int>(
          items: sequenceNumbers
              .map((value) => DropdownMenuItem(
            child: Text(
              '$value',
              style: TextStyle(color: Colors.redAccent),
            ),
            value: value,
          ))
              .toList(),
          hint: Align(
            alignment: Alignment.center,
            child: Text('Year of admission'),
          ),
          validator: (value) {
            if (value == null) {
              return 'Please Select your choice';
            }
            return null;
          },
          value: selectedYear,
          onChanged: (int? newValue) {
            setState(() {
              selectedYear = newValue;

              print("PRINT VALUE=== $selectedYear");
            });
            print(selectedYear);
          },
        ),
      ],
    );

    final passoutYearFeild = Column(
      children: [
        DropdownButton<int>(
          items: sequenceNumbers
              .map((value) => DropdownMenuItem(
            child: Text(
              '$value',
              style: TextStyle(color: Colors.redAccent),
            ),
            value: value,
          ))
              .toList(),
          hint: Align(
            alignment: Alignment.center,
            child: Text('Passout year'),
          ),
          value: selectedYear,
          onChanged: (int? newValue) {
            setState(() {
              selectedYear = newValue;

              print("PRINT VALUE=== $selectedYear");
            });
            print(selectedYear);
          },
        ),
      ],
    );
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.redAccent,
      child: MaterialButton(
        onPressed: () {
          signUp(emailEditingcontroller.text, passwordEditingcontroller.text);
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          'SignUp',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    // Center(
                    //   child: InkWell(
                    //     onTap: () {
                    //       showOptionsDialog(context);
                    //     },
                    //     child: Text(
                    //       "Add Picture",
                    //
                    //       ),
                    //     ),
                    //   ),
                    userTypeFeild,
                    SizedBox(
                      height: 25,
                    ),
                    emailField,
                    SizedBox(
                      height: 25,
                    ),
                    passwordFeild,
                    SizedBox(
                      height: 25,
                    ),
                    nameFeild,
                    SizedBox(
                      height: 25,
                    ),
                    mobileFeild,
                    SizedBox(
                      height: 25,
                    ),
                    collegeNameFeild,
                    SizedBox(
                      height: 25,
                    ),

                    usertypeValue == "Student" ? admissionYear : SizedBox(),
                    usertypeValue == "Almuni" ? passoutYearFeild : SizedBox(),

                    SizedBox(
                      height: 25,
                    ),
                    // passoutYearFeild,
                    SizedBox(
                      height: 25,
                    ),

                    _image != null
                        ? Image.file(
                      File(_image!.path),
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fitHeight,
                    )
                        : Container(),
                    SizedBox(
                      height: 25,
                    ),

                    Text('PICK IMAGE FROM:'),
                    imageTypeFeild,

                    SizedBox(
                      height: 25,
                    ),
                    signUpButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()});
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

//
//     // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameEditingcontroller.text;
    userModel.password = passwordEditingcontroller.text;
    userModel.phoneNumber = int.parse(mobileEditingcontroller.text);
    userModel.collegeName = collegeEditingcontroller.text;
    userModel.year = int.parse("$selectedYear");
    userModel.userType = usertypeValue.toString();
    userModel.imgURL = imageUrl;
//
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
//     Fluttertoast.showToast(msg: "Account created successfully :) ");
//
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
  }
}
