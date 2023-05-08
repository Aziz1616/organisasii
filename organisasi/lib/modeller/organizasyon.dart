import 'package:cloud_firestore/cloud_firestore.dart';

class Organizasyon {
  final String? id;
  final String? aciklama;
  final String? yayinlayanId;
  final String? baslik;
  final String? konum;
  final Timestamp? tarih;
  final Timestamp? olusturulmaZamani;
  Organizasyon(
      {required this.id,
      required this.aciklama,
      required this.yayinlayanId,
      required this.baslik,
      required this.tarih,
      required this.konum,
      required this.olusturulmaZamani});
  factory Organizasyon.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc.data();
    return Organizasyon(
        id: doc.id,
        aciklama: doc['aciklama'],
        yayinlayanId: doc['yayinlayanId'],
        baslik: doc['baslik'],
        konum: doc['konum'],
        tarih: doc['tarih'],
        olusturulmaZamani: doc['olusturulmaZamani']);
  }
}
