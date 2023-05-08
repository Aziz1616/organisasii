import 'package:cloud_firestore/cloud_firestore.dart';

class Kullanici {
  final String id;
  final String? kullaniciAdi;
  final String? fotoUrl;
  final String? email;
  final String? telNo;

  Kullanici(
      {required this.id,
      required this.kullaniciAdi,
      required this.fotoUrl,
      required this.email,
      required this.telNo});

  factory Kullanici.firebasedenUret(kullanici) {
    return Kullanici(
      id: kullanici.uid,
      kullaniciAdi: kullanici.displayName,
      fotoUrl: kullanici.photoURL,
      email: kullanici.email,
      telNo: '',
    );
  }

  factory Kullanici.dokumandanUret(DocumentSnapshot doc) {
    var docData = doc.data();
    return Kullanici(
      id: doc.id,
      kullaniciAdi: doc['kullaniciAdi'],
      email: doc['email'],
      fotoUrl: doc['fotoUrl'],
      telNo: doc['telNo'],
    );
  }
}
