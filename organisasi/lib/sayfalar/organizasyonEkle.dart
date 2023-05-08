import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart ' hide Text;
import 'package:intl/intl.dart';
import 'package:organisasi/modeller/kullanici.dart';
import 'package:organisasi/sayfalar/loginedSayfalari/loginnedOrganizasyonlar.dart';
import 'package:organisasi/servisler/firestoreServisi.dart';

class OrganizasyonEkle extends StatefulWidget {
  const OrganizasyonEkle({super.key, required this.organizasyonSahibi});
  final Kullanici organizasyonSahibi;

  @override
  State<OrganizasyonEkle> createState() => _OrganizasyonEkleState();
}

class _OrganizasyonEkleState extends State<OrganizasyonEkle> {
  DateTime? tarih;
  late String baslik;
  String textKelime = '';
  bool yukleniyor = false;
  final formKey = GlobalKey<FormState>();
  String konum = '';

  QuillController _controller = QuillController.basic();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizasyon Ekle'),
      ),
      body: ListView
      (
        shrinkWrap: true,
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: TextFormField(
              initialValue: '',
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.text_decrease),
                labelText: 'Organizasyon Başlığı',
                hintText: 'Başlık',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Organizasyon başlığı boş bırakılamaz';
                }
                return null;
              },
              onSaved: (newValue) => baslik = newValue!,
            ),
          ),
        ),
        TextFormField(
          initialValue: tarih == null
              ? 'Tarih Seçmek için basınız'
              : DateFormat('dd/MM/yyyy').format(tarih!),
          keyboardType: TextInputType.datetime,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.calendar_month),
            labelText: 'Organizasyon Tarihi',
            hintText: 'Organizasyon Tarihi',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Organizasyon tarihi boş bırakılamaz';
            }
            return null;
          },
          onTap: () async {
            final seciliTarih = await seciliTraih();
            if (seciliTarih == null) return;
            setState(() {
              tarih = seciliTarih;
            });
          },
        ),

        /*
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: Text(tarih == null
                ? 'Tarih Seçmek için basınız'
                : DateFormat('dd/MM/yyyy').format(tarih!)),
            onPressed: () async {
              final seciliTarih = await seciliTraih();
              if (seciliTarih == null) return;
              setState(() {
                tarih = seciliTarih;
              });
            },
          ),
        ),
        */
        TextFormField(
          initialValue: '',
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.text_decrease),
            labelText: 'İl/İlçe Giriniz',
            hintText: 'İl/İlçe',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'İl/İlçe bilgisi boş bırakılamaz';
            }
            return null;
          },
          onSaved: (newValue) => konum = newValue!,
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QuillToolbar.basic(
            controller: _controller,
            locale: const Locale('tr'),
            fontSizeValues: const {
              'Small': '7',
              'Medium': '20.5',
              'Large': '40',
            },
            showAlignmentButtons: false,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          //width: MediaQuery.of(context).size.width * 0.5,
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.lightBlueAccent,
                offset: Offset(5.0, 5.0),
                blurRadius: 10,
                spreadRadius: 2),
            BoxShadow(
                color: Colors.white,
                offset: Offset(
                  0.0,
                  0.0,
                ),
                blurRadius: 0,
                spreadRadius: 0)
          ]),
          child: QuillEditor.basic(controller: _controller, readOnly: false),
        ),
        TextButton(
            onPressed: () {
              kaydet();
            },
            child: const Text('Yayınlamaya Gönder'))
      ]),
    );
  }

  Future<DateTime?> seciliTraih() => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2500));

  kaydet() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FirestoreServisi().organizasyonolustur(
          aciklama: _controller.document.toPlainText(),
          baslik: baslik,
          yayinlayaId: widget.organizasyonSahibi.id,
          konum: konum,
          tarih: Timestamp.fromDate(tarih!));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginnedOrganizasyonlarSayfasi()));
    }
  }
}
