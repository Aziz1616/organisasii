import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organisasi/modeller/kullanici.dart';
import 'package:organisasi/modeller/organizasyon.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrganizasyonKarti extends StatefulWidget {
  const OrganizasyonKarti(
      {super.key, required this.organizasyon, required this.yayinlayanSahib});
  final Organizasyon organizasyon;
  final Kullanici? yayinlayanSahib;

  @override
  State<OrganizasyonKarti> createState() => _OrganizasyonKartiState();
}

class _OrganizasyonKartiState extends State<OrganizasyonKarti> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
  }

  @override
  Widget build(BuildContext context) {
    return
        //burada kullanicilar çekilecek ve iletişim numarası eklenecek
        Column(
         // shrinkWrap: true,
          children: [
            _organizasyonKarti(context),
          ],
        );
  }

  Padding _organizasyonKarti(BuildContext context) {
    return Padding(
        padding:  EdgeInsets.only(top: 10, left: 2, right: 2, bottom: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)),
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'FanDesing',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kDefaultIconDarkColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    timeago.format(
                      widget.organizasyon.olusturulmaZamani!.toDate(),
                      locale: 'tr',
                    ),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                widget.organizasyon.baslik!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  color: kDefaultIconDarkColor,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.organizasyon.aciklama!,
                maxLines: 4,
                style: const TextStyle(height: 1.5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.organizasyon.konum!,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(
                      widget.organizasyon.tarih!.toDate().add(hours(7))),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Kalan Gün=${widget.organizasyon.tarih!.toDate().difference(DateTime.now()).inDays}',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.yayinlayanSahib!.kullaniciAdi.toString(),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                widget.yayinlayanSahib!.telNo == null
                    ? const Text('Tel No yok')
                    : Text(
                        widget.yayinlayanSahib!.telNo.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
              ],
            )
          ]),
        ));
  }
}
