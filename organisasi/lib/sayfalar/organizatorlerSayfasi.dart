import 'package:flutter/material.dart';
import 'package:organisasi/sayfalar/girisYap.dart';

class OrganizatorlerSayfasi extends StatefulWidget {
  const OrganizatorlerSayfasi({super.key});

  @override
  State<OrganizatorlerSayfasi> createState() => _OrganizatorlerSayfasiState();
}

class _OrganizatorlerSayfasiState extends State<OrganizatorlerSayfasi> {
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const GirisYap()));
            },
            child: const Text('Giriş Yap'))
      ]),
    );
  }
}
