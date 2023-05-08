import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organisasi/modeller/kullanici.dart';
import 'package:organisasi/modeller/organizasyon.dart';

import 'package:organisasi/sayfalar/girisYap.dart';
import 'package:organisasi/sayfalar/hesapOlustur.dart';
import 'package:organisasi/servisler/firestoreServisi.dart';
import 'package:organisasi/widgetlar/organizasyonKarti.dart';

class OrganizasyonlarSayfasi extends StatefulWidget {
  const OrganizasyonlarSayfasi({
    super.key,
  });

  @override
  State<OrganizasyonlarSayfasi> createState() => _OrganizasyonlarSayfasiState();
}

class _OrganizasyonlarSayfasiState extends State<OrganizasyonlarSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ShowDialog();
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
      body: ListView(shrinkWrap: true, children: [
        StreamBuilder<QuerySnapshot<Object?>>(
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
                        Kullanici organizasyonSahibi = snapshot.data!;

                        return ListView(
                          shrinkWrap: true,
                          children: [
                            OrganizasyonKarti(
                              organizasyon: organizasyon,
                              yayinlayanSahib: organizasyonSahibi,
                            ),
                          ],
                        );
                      },
                    );
                  });
            })
      ]),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title) {
    return PopupMenuItem(
      child: Column(children: [
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const GirisYap()));
            },
            child: const Text('Giriş Yap'))
      ]),
    );
  }

  _ShowDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Lütfen Önce Giriş Yapınız'),
            children: [
              SimpleDialogOption(
                child: const Text('Giriş Yap'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GirisYap()));
                },
              ),
              SimpleDialogOption(
                child: const Text('Üye Ol'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HesapOlustur()));
                },
              ),
              SimpleDialogOption(
                child: const Text('Kapat'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
