import 'package:flutter/material.dart';
import 'package:organisasi/sayfalar/anaSayfa.dart';
import 'package:organisasi/servisler/firestoreServisi.dart';
import 'package:organisasi/yonlendirme.dart';
import 'package:provider/provider.dart';

import '../modeller/kullanici.dart';
import '../servisler/yetkilendirmeServisi.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({super.key});

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  late String kullaniciAdi, email, sifre, telNo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      appBar: AppBar(title: const Text('Hesap Oluştur')),
      body: ListView(
        children: [
          yukleniyor
              ? const LinearProgressIndicator()
              : const SizedBox(
                  height: 0,
                ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formAnahtari,
              child: Column(
                children: [
                  TextFormField(
                      autocorrect: true,
                      decoration: const InputDecoration(
                        hintText: 'Kullanıcı adınızı giriniz',
                        labelText: 'Kullanıcı adı:',
                        errorStyle: TextStyle(fontSize: 16),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (girilenDeger) {
                        if (girilenDeger!.isEmpty) {
                          return 'Kullanıcı alanı boş bırakılamaz';
                        } else if (girilenDeger.trim().length < 4 ||
                            girilenDeger.trim().length > 10) {
                          return 'En az 4 en fazla 10 karakter olmalı';
                        }
                        return null;
                      },
                      onSaved: (girilenDeger) => kullaniciAdi = girilenDeger!),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    autocorrect: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email adresinizi giriniz',
                      labelText: 'Mail:',
                      errorStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(
                        Icons.mail,
                      ),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger!.isEmpty) {
                        return 'Email alanı boş bırakılamaz';
                      } else if (!girilenDeger.contains('@')) {
                        return 'Girilen değer mail formatında olmalı';
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => email = girilenDeger!,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Şifrenizi giriniz',
                      labelText: 'Şifre:',
                      errorStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger!.isEmpty) {
                        return 'Şifre alanı boş bırakılamaz';
                      } else if (girilenDeger.trim().length < 6) {
                        return 'Şifre az 6 karakter olmalı';
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => sifre = girilenDeger!,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'İletişim No Giriniz',
                      labelText: 'İletişim No:',
                      errorStyle: TextStyle(fontSize: 16),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger!.isEmpty) {
                        return 'Tel No alanı boş bırakılamaz';
                      } else if (girilenDeger.trim().length != 11) {
                        return '11 Haneli olmalı';
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) => telNo = girilenDeger!,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: TextButton(
                      onPressed: _kullaniciOlustur,
                      child: const Text(
                        'Hesap Oluştur',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;
    if (_formState!.validate()) {
      _formState.save();

      setState(() {
        yukleniyor = true;
      });

      try {
        Kullanici? kullanici =
            await _yetkilendirmeServisi.mailIleKayit(email, sifre);
        if (kullanici != null) {
          FirestoreServisi().kullaniciOlustur(
              id: kullanici.id,
              email: email,
              kullaniciAdi: kullaniciAdi,
              );
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Yonlendirme()));
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.hashCode);
      }
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "email-already-in-use") {
      hataMesaji = "Girdiğiniz mail adresi dah önce kullanılmış";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Geçersin e posta adresi";
    } else if (hataKodu == "operation-not-allowed") {
      hataMesaji = "Daha zor bir şifre tercih edin";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu $hataKodu";
    }
    var snackBar = SnackBar(content: Text(hataMesaji));
//yeni kullanım
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
