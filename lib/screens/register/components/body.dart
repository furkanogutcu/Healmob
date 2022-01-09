import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/components/already_have_an_account.dart';
import 'package:healmob/components/rounded_button.dart';
import 'package:healmob/components/rounded_dropdown.dart';
import 'package:healmob/components/rounded_form_input_field.dart';
import 'package:healmob/components/rounded_form_password_field.dart';
import 'package:healmob/components/swap_doctor_patient_screen.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/anabilim_dali_api.dart';
import 'package:healmob/data/doktor_api.dart';
import 'package:healmob/data/hasta_api.dart';
import 'package:healmob/models/anabilim_dali.dart';
import 'package:healmob/models/api_response/api_get_response.dart';
import 'package:healmob/models/api_response/api_post_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/validation/hasta_validator.dart';

var _isPatient = true;
AnabilimDali selectedAnabilimDali = AnabilimDali(-1, "Anabilim dali seçiniz");
String gender = "Cinsiyetiniz";

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with HastaValidationMixin {
  List<AnabilimDali> anabilimDaliList = <AnabilimDali>[selectedAnabilimDali];
  final _formKey = GlobalKey<FormState>();
  var hasta = Hasta(1, "", "", "", "", "", false, false, "");
  var doktor = Doktor(1, -1, "", "", "", "", "", false, false, "");

  @override
  void initState() {
    getAllAnabilimDaliFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
            duration: defaultDuration,
            child: _isPatient
                ? Text(
                    "HASTA KAYIT",
                    key: UniqueKey(),
                  )
                : Text("DOKTOR KAYIT", key: UniqueKey())),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.03,
              ),
              AnimatedSwitcher(
                duration: defaultDuration,
                child: _isPatient
                    ? SvgPicture.asset(
                        "assets/images/patient_register.svg",
                        height: size.height * 0.35,
                        key: UniqueKey(),
                      )
                    : SvgPicture.asset("assets/images/doctor_register.svg",
                        height: size.height * 0.35, key: UniqueKey()),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SwapDoctorPatientScreen(
                onPress: () {
                  setState(() {
                    _isPatient = !_isPatient;
                    _formKey.currentState!.reset();
                  });
                },
                isPatient: _isPatient,
                isLoginScreen: false,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    RoundedFormInputField(
                      hintText: "Adınız",
                      icon: Icons.person,
                      onChanged: (value) {},
                      validator: validateFirstName,
                      onSaved: (value) {
                        _isPatient
                            ? hasta.ad = value.toString()
                            : doktor.ad = value.toString();
                      },
                    ),
                    RoundedFormInputField(
                      hintText: "Soyadınız",
                      icon: Icons.person,
                      onChanged: (value) {},
                      validator: validateLastName,
                      onSaved: (value) {
                        _isPatient
                            ? hasta.soyad = value.toString()
                            : doktor.soyad = value.toString();
                      },
                    ),
                    RoundedFormInputField(
                      hintText: "E-posta adresiniz",
                      icon: Icons.email,
                      onChanged: (value) {},
                      validator: validateEmail,
                      onSaved: (value) {
                        _isPatient
                            ? hasta.email = value.toString()
                            : doktor.email = value.toString();
                      },
                    ),
                    RoundedFormPasswordField(
                      onChanged: (value) {},
                      validator: validatePassword,
                      onSaved: (value) {
                        _isPatient
                            ? hasta.sifre = value.toString()
                            : doktor.sifre = value.toString();
                      },
                    ),
                    RoundedFormInputField(
                      hintText: "Telefon numaranız",
                      icon: Icons.phone,
                      onChanged: (value) {},
                      validator: validatePhone,
                      onSaved: (value) {
                        _isPatient
                            ? hasta.telefon = value.toString()
                            : doktor.telefon = value.toString();
                      },
                    ),
                    if (!_isPatient)
                      RoundedDropdown<AnabilimDali>(
                        icon: Icons.assignment_ind_rounded,
                        onChanged: (value) {
                          setState(() {
                            selectedAnabilimDali = value!;
                          });
                        },
                        items: anabilimDaliList
                            .map((a) => DropdownMenuItem(
                                  child: Text(a.anabilimDaliAdi),
                                  value: a,
                                ))
                            .toList(),
                        selectedValue: selectedAnabilimDali,
                      ),
                    RoundedDropdown<String>(
                      icon: Icons.wc,
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                      items: ["Cinsiyetiniz", "Erkek", "Kadın"]
                          .map((c) => DropdownMenuItem(
                                child: Text(c),
                                value: c,
                              ))
                          .toList(),
                      selectedValue: gender,
                    ),
                  ],
                ),
              ),
              RoundedButton(
                buttonText:
                    (_isPatient ? "Hasta" : "Doktor ") + " kaydını oluştur",
                onPress: () {
                  createUser();
                },
              ),
              AlreadyHaveAnAccountCheck(
                onPress: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", ModalRoute.withName('/'));
                },
                login: false,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAllAnabilimDaliFromApi() {
    AnabilimDaliApi.getAll().then((response) {
      ApiGetResponse apiResponse =
          ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        setState(() {
          anabilimDaliList =
              apiResponse.data.map((a) => AnabilimDali.fromJson(a)).toList();
          anabilimDaliList.insert(0, selectedAnabilimDali);
        });
      }
    });
  }

  void createUser() {
    if (_formKey.currentState!.validate()) {
      if (gender == "Cinsiyetiniz") {
        _showAlert(
            context, "Cinsiyet boş olamaz", "Lütfen cinsiyetinizi seçiniz");
        return;
      }
      bool boolGender = gender != "Erkek";
      _formKey.currentState!.save();
      if (_isPatient) {
        hasta.cinsiyet = boolGender;
        createHastaToApi(hasta);
      } else {
        if (selectedAnabilimDali.anabilimDaliNo == -1) {
          _showAlert(context, "Anabilim dalı boş olamaz",
              "Lütfen anabilim dalınızı seçiniz");
          return;
        }
        doktor.cinsiyet = boolGender;
        doktor.anabilimDaliNo = selectedAnabilimDali.anabilimDaliNo;
        createDoktorToApi(doktor);
      }
    }
  }

  void _showAlert(BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void _showRegisterSuccessfulAlert(
      BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (BuildContext context) => alert)
        .then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/login", ModalRoute.withName('/'));
    });
  }

  createHastaToApi(Hasta hasta) {
    HastaApi.add(hasta).then((response) {
      ApiPostResponse apiResponse =
          ApiPostResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        _showRegisterSuccessfulAlert(
            context, "Hasta kaydı başarılı", "Kaydınız başarıyla oluşturuldu");
      } else {
        _showAlert(
            context,
            "Hasta kaydı başarısız",
            "Kaydınız sırasında bir şeyler ters gitti\n\n" +
                apiResponse.message);
      }
    });
  }

  createDoktorToApi(Doktor doktor) {
    DoktorApi.add(doktor).then((response) {
      ApiPostResponse apiResponse =
          ApiPostResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        _showRegisterSuccessfulAlert(
            context, "Doktor kaydı başarılı", "Kaydınız başarıyla oluşturuldu");
      } else {
        _showAlert(
            context,
            "Doktor kaydı başarısız",
            "Kaydınız sırasında bir şeyler ters gitti\n\n" +
                apiResponse.message);
      }
    });
  }
}
