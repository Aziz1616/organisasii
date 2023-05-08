import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organisasi/modeller/kullanici.dart';

class FirestoreServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime zaman = DateTime.now();

  Future<void> kullaniciOlustur({
    id,
    email,
    kullaniciAdi,
    telNo,
  }) async {
    await _firestore.collection('kullanicilar').doc(id).set({
      'kullaniciAdi': kullaniciAdi,
      'email': email,
      'fotoUrl': '',
      'telNo': ' ',
      'olusturulmaZamani': zaman,
    });
  }

//eğer kullanıc daha önceden giriş yaptıysa aynı kullanıcıyı tekrardan
//kullanıcılar verisine kayıt yaptırmamak gerekir bunun için
//kullanıcıları getir methodu çağırılır
  Future<Kullanici?> kullaniciGetir(id) async {
    DocumentSnapshot doc =
        await _firestore.collection('kullanicilar').doc(id).get();
    if (doc.exists) {
      Kullanici kullanici = Kullanici.dokumandanUret(doc);
      return kullanici;
    }

    return null;
  }

  void kullaniciGuncelle(
      {required String kullaniciId,
      required String kullaniciAdi,
      String fotoUrl = '',
      required String hakkinda}) {
    _firestore.collection('kullanicilar').doc(kullaniciId).update({
      'kullaniciAdi': kullaniciAdi,
      'hakkinda': hakkinda,
      'fotoUrl': fotoUrl,
    });
  }

  Future<List<Kullanici>> kullaniciAra(String kelime) async {
    QuerySnapshot snapshot = await _firestore
        .collection('kullanicilar')
        .where('kullaniciAdi', isGreaterThanOrEqualTo: kelime)
        .get();
    List<Kullanici> kullanicilar =
        snapshot.docs.map((doc) => Kullanici.dokumandanUret(doc)).toList();
    return kullanicilar;
  }

  Stream<QuerySnapshot> organizasyonlariGetir() {
    return _firestore
        .collection('Organizasyonlar')
        .orderBy('tarih', descending: false)
        .snapshots();
  }

  Future<void> organizasyonolustur({
    //required String id,
    required String aciklama,
    required String baslik,
    required String yayinlayaId,
    required String konum,
    required Timestamp tarih,
  }) async {
    await _firestore.collection('Organizasyonlar').add({
      'yayinlayanId': yayinlayaId,
      'baslik': baslik,
      'olusturulmaZamani': zaman,
      'aciklama': aciklama,
      'tarih': tarih,
      'konum': konum,
    });
  }
}
