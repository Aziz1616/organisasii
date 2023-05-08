import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organisasi/modeller/organizasyon.dart';
import 'package:organisasi/sayfalar/organizasyonEkle.dart';

import 'package:organisasi/servisler/firestoreServisi.dart';
import 'package:organisasi/servisler/yetkilendirmeServisi.dart';
import 'package:organisasi/widgetlar/organizasyonKarti.dart';

import 'package:provider/provider.dart';

import '../../modeller/kullanici.dart';

class LoginnedOrganizasyonlarSayfasi extends StatefulWidget {
  const LoginnedOrganizasyonlarSayfasi({
    super.key,
  });

  @override
  State<LoginnedOrganizasyonlarSayfasi> createState() =>
      _LoginnedOrganizasyonlarSayfasiState();
}

class _LoginnedOrganizasyonlarSayfasiState
    extends State<LoginnedOrganizasyonlarSayfasi> {
  late Kullanici? organizasyonSahibi;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrganizasyonEkle(
                        organizasyonSahibi: organizasyonSahibi!,
                      )));
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
          width: 250,
          child: ListView(
            children: const [
              UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2023/04/24/17/48/bird-7948712_960_720.jpg'),
                  ),
                  accountName: Text('data'),
                  accountEmail: Text('skjnj')),
              ListTile(
                title: Text('Oragnisasi'),
              )
            ],
          )),
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [_buildPopupMenuItem('  ')],
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          )
        ],
        title: const Text('Organizasyonlar'),
      ),
      body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: FirestoreServisi().organizasyonlariGetir(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Organizasyon organizasyon =
                      Organizasyon.dokumandanUret(snapshot.data!.docs[index]);
                  return FutureBuilder(
                    future: FirestoreServisi()
                        .kullaniciGetir(organizasyon.yayinlayanId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox(
                          height: 0,
                        );
                      }
                      organizasyonSahibi = snapshot.data;

                      return ListView(
                        // shrinkWrap: true,
                        children: [
                          OrganizasyonKarti(
                            organizasyon: organizasyon,
                            yayinlayanSahib: organizasyonSahibi,
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      );
                    },
                  );
                });
          }),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title) {
    return PopupMenuItem(
      child: Column(children: [
        TextButton(
            onPressed: () {
              Provider.of<YetkilendirmeServisi>(context as BuildContext,
                      listen: false)
                  .cikisYap();
              Navigator.pop(context);
            },
            child: const Text('Çıkış Yap'))
      ]),
    );
  }
}
