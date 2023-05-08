import 'package:flutter/material.dart';
import 'package:organisasi/sayfalar/hesapOlustur.dart';
import 'package:organisasi/sayfalar/sifremiUnuttum.dart';
import 'package:organisasi/yonlendirme.dart';
import 'package:provider/provider.dart';

import '../modeller/kullanici.dart';
import '../servisler/firestoreServisi.dart';
import '../servisler/yetkilendirmeServisi.dart';

class GirisYap extends StatefulWidget {
  const GirisYap({super.key});

  @override
  State<GirisYap> createState() => _GirisYapState();
}

class _GirisYapState extends State<GirisYap> {
  final _formAnahtari = GlobalKey<FormState>();
  final _scaffoldAnahtari = GlobalKey<ScaffoldState>();
  bool yukleniyor = false;
  late String email, sifre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      body: Stack(children: [_sayfaElemanlari(), _yuklemeAnimasyonu()]),
    );
  }

  Widget _yuklemeAnimasyonu() {
    if (yukleniyor) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return const SizedBox(
        height: 0.0,
      );
    }
  }

  Widget _sayfaElemanlari() {
    return Form(
        key: _formAnahtari,
        child: ListView(
          children: [
            Image.asset(
              'assets/images/organisasi.jpg',
              height: 300,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              autocorrect: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email adresinizi giriniz',
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
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Şifrenizi giriniz',
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
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HesapOlustur()));
                  },
                  child: const Text('Hesap Oluştur'),
                )),
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    _girisYap();
                  },
                  child: const Text('Giriş Yap'),
                )),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            const Center(child: Text('Veya')),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: _googleIleGiris,
                child: const Text(
                  'Google ile giriş yap',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SifremiUnuttum()));
                    },
                    child: const Text('Şifremi unuttum'))),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  void _girisYap() async {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formState = _formAnahtari.currentState;
    if (_formState!.validate()) {
      _formState.save();
      setState(() {
        yukleniyor = true;
      });
      try {
        await _yetkilendirmeServisi.mailIleGiris(email, sifre);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Yonlendirme()));
      } catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        uyariGoster(hataKodu: hata.hashCode);
      }
    }
  }

  void _googleIleGiris() async {
    var _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    setState(() {
      yukleniyor = true;
    });
    try {
      Kullanici? kullanici = await _yetkilendirmeServisi.googleIleGiris();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Yonlendirme()));
      Kullanici? firestoreKullanici =
          await FirestoreServisi().kullaniciGetir(kullanici?.id);

      if (firestoreKullanici == null) {
        FirestoreServisi().kullaniciOlustur(
            id: kullanici?.id,
            email: kullanici?.email,
            kullaniciAdi: kullanici?.kullaniciAdi,
            );
      }
    } catch (hata) {
      setState(() {
        yukleniyor = false;
      });
      uyariGoster(hataKodu: hata.hashCode);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "user-not-found") {
      hataMesaji = "Böyle bir kullanıcı bulunmuyor";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen şifre hatalı";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Kullanıcı engellenmiş";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu $hataKodu";
    }
    var snackBar = SnackBar(content: Text(hataMesaji));
//yeni kullanım
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
