import 'package:flutter/material.dart';
import 'package:organisasi/sayfalar/akis.dart';

import 'package:organisasi/sayfalar/organizasyonlarSayfasi.dart';
import 'package:organisasi/sayfalar/organizatorlerSayfasi.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifSayfaNo = 0;
  late PageController sayfaKumandasi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    sayfaKumandasi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: sayfaKumandasi,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (acilanSayfaNo) {
          setState(() {
            _aktifSayfaNo = acilanSayfaNo;
          });
        },
        children: [
          Akis(),
          OrganizasyonlarSayfasi(),
          OrganizatorlerSayfasi()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifSayfaNo,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Akış'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Organizasyonlar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Organizatör Firmalar'),
        ],
        onTap: (secilenSayfaNo) {
          setState(() {
            sayfaKumandasi.jumpToPage(secilenSayfaNo);
          });
        },
      ),
    );
  }
}
