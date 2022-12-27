# Di Tonton Aja

## Tips Untuk menjalankan project ini

1. Buat file .env berdasarkan .env.example (Wajib)
2. Ubah apikey dengan apikey yang anda punya. jika anda belum memiliki apikey anda dapat mengenerate di link https://developers.themoviedb.org (Wajib)

3. Masuk ke dalam direktory `android/app` kemudian masukan `google-services.json` anda. (Wajib)

## Tips untuk build applikasi ini

1. Pastikan anda sudah memastikan bahwasanya anda sudah mengikuti step yang ada diatas dan aplikasi dapat berjalan dengan baik.

2. Masuk ke directory `android` kemudian buat file key.properties dan masukan kredensial untuk keperluan build. contoh

   ```grovy
   storePassword=
   keyPassword=
   keyAlias=
   storeFile=
   ```

3. Jangan lupa untuk memasukan keystone.jks anda kedalam folder `android/app/` dan pastikan anda memberi nama sesuai dengan storeFile yang ada di key.properties

## Information

Adapun screnshut dapat anda liahat di folder `resources/` dari implementasi seperti

- firebase crashanalytic
- firebase analytic
- status build implementasi github ci/cd

link build ci/cd dapat anda lihat di link berikut
https://github.com/mahmudph/flutter-tv-series-dicoding-expert/actions
