import 'package:flutter/material.dart';
import 'package:organisasi/modeller/kullanici.dart';
import 'package:organisasi/sayfalar/anaSayfa.dart';
import 'package:organisasi/sayfalar/loginedSayfalari/loginnedAnaSayfa.dart';
import 'package:organisasi/servisler/yetkilendirmeServisi.dart';
import 'package:provider/provider.dart';

class Yonlendirme extends StatelessWidget {
  const Yonlendirme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi =
        Provider.of<YetkilendirmeServisi>(context, listen: false);
    return StreamBuilder(
      stream: _yetkilendirmeServisi.durumTakipcisi,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          Kullanici? aktifKullanici = snapshot.data;
          _yetkilendirmeServisi.aktifKulaniciId = aktifKullanici!.id;

          return LoginnedAnasayfa();
        } else {
          return AnaSayfa();
        }
      },
    );
  }
}
