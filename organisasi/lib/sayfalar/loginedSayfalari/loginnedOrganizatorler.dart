import 'package:flutter/material.dart';
import 'package:organisasi/sayfalar/girisYap.dart';
import 'package:provider/provider.dart';

import '../../servisler/yetkilendirmeServisi.dart';

class LoginnedOrganizatorlerSayfasi extends StatefulWidget {
  const LoginnedOrganizatorlerSayfasi({super.key});

  @override
  State<LoginnedOrganizatorlerSayfasi> createState() => _LoginnedOrganizatorlerSayfasiState();
}

class _LoginnedOrganizatorlerSayfasiState extends State<LoginnedOrganizatorlerSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        title: const Text('Organizatörler'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [_buildPopupMenuItem('  ')],
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          )
        ],
      ),
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
