# Flowin — Post-Redesign Bug Fix & Functional Hardening Report

## 1. Executive Summary

Keempat bug pasca-redesign pada aplikasi **Flowin** (design system *Ocean Mist & Deep Current*, state management `FlowinAppState` + `FlowinScope`) telah diinvestigasi, diperbaiki berdasarkan akar masalahnya, dan diverifikasi di seluruh jalur unit/widget test, build **Android (APK)** dan **Flutter Web**, serta pengujian interaktif end-to-end menggunakan **Playwright (Chromium)** dan perangkat fisik Android **vivo 1935** (`fb4262f2`).

Ringkasan pencapaian:
- Seluruh siklus hidup `TextEditingController` di modal bottom sheet (`Edit Delivery Address`, `Add Payment Method`, dan `Reset Password` / Forgot Password) dipindahkan ke `StatefulWidget` (`State.dispose`), sehingga controller tidak lagi di-dispose sebelum animasi penutupan modal dan pelepasan fokus (`FocusNode`) selesai.
- Validasi input form ditambahkan secara konsisten melalui `FlowinValidators`, serta `FlowinTextField` diperbarui (`errorMaxLines: 2`) agar pesan validasi yang panjang membungkus rapi di viewport mobile tanpa elipsis.
- Fitur upload, preview, ganti, dan hapus foto profil telah diimplementasikan lintas platform Android dan Flutter Web melalui abstraksi `ProfilePhotoPicker` (`ImagePickerProfilePhotoPicker` berbasis `image_picker`), validasi ukuran (`<= 5 MB`) serta ekstensi/magic-bytes gambar, dan sinkronisasi reaktif `Uint8List? profilePhotoBytes` di `FlowinAppState` (`ProfileHeaderCard` & `PersonalInformationScreen`).
- Seluruh pemeriksaan akhir lulus tanpa error: `flutter analyze` (`No issues found!`), `flutter test` (`+15: All tests passed!`), `flutter build web --no-wasm-dry-run`, `flutter build apk --debug`, Playwright Web QA (`0` console/page error), dan Android device QA di `vivo 1935` (`0` runtime/Flutter error).

---

## 2. Daftar Bug yang Ditemukan

1. **Bug #1 — Delivery Address Update Error**: Mengubah isi alamat pada modal Edit Delivery Address lalu menekan **Save** memicu exception lifecycle (`TextEditingController was used after being disposed`), meskipun data alamat sudah tersimpan; sedangkan menekan **Save** tanpa mengedit teks sering tampak normal.
2. **Bug #2 — Add Payment Method Error**: Menambahkan metode pembayaran melalui `PaymentMethodsScreen` atau `CheckoutScreen` menghasilkan pola exception lifecycle modal/controller yang serupa serta belum memvalidasi input kosong/tidak lengkap dan ikon/notifikasi secara aman.
3. **Bug #3 — Profile Photo Upload Not Implemented**: `PersonalInformationScreen` dan `ProfileHeaderCard` hanya menampilkan avatar statis `CircleAvatar` (`Icons.person_rounded`), belum mendukung pemilihan gambar dari galeri di Android/Web, preview `Image.memory`, validasi format/ukuran file, penanganan cancel/error, maupun penghapusan foto.
4. **Bug #4 — Forgot Password / Send Recovery Link Error & Missing Validation**: Modal **Reset Password** di `LoginScreen` belum memvalidasi email kosong/malformed, menggunakan pola modal controller yang rawan exception saat ditutup, dan menampilkan pesan seolah-olah recovery email sungguhan telah dikirim (`"dispatched"`) alih-alih simulasi frontend yang jelas dan tombol kembali ke Login yang aman.
5. **Temuan visual tambahan saat QA**: Pesan validasi email di `FlowinTextField` sempat terpotong elipsis (`Enter a valid email address (e.g. name@flowin.i...`) pada lebar viewport mobile (`390px`) karena `errorMaxLines` default bernilai `1`.

---

## 3. Root Cause Setiap Bug

1. **Bug #1 & Bug #2 (`TextEditingController` premature disposal + context/lifecycle ordering)**  
   Modal bottom sheet sebelumnya dibuat langsung dengan fungsi `showModalBottomSheet` yang menginisialisasi `TextEditingController` di scope fungsi pemanggil lalu memanggil `ctrl.dispose()` di dalam `.whenComplete(...)`. Ketika rute `ModalBottomSheetRoute` ditutup (`Navigator.pop`), `FocusNode` di `FlowinTextField` melepaskan fokus dan memicu `setState(() => _hasFocus = _focusNode.hasFocus)` saat widget sheet masih melakukan animasi keluar (`exit transition`). Akibatnya `TextFormField` melakukan rebuild dengan controller yang sudah di-dispose ketika pengguna sebelumnya memfokuskan/mengedit field — sementara saat pengguna tidak mengedit/memfokuskan field, crash kadang tidak muncul. Selain itu di `PaymentMethodsScreen._openTopUpSheet`, `FlowinToast.show` dipanggil tanpa pemeriksaan `context.mounted`.

2. **Bug #3 (Belum tersedianya state, picker abstraction, validasi bytes, dan avatar renderer)**  
   `FlowinAppState` belum menyimpan bytes gambar profil (`Uint8List?`), `ProfileHeaderCard` me-render `CircleAvatar` dengan ikon hardcoded, dan `PersonalInformationScreen` belum memiliki dependency picker lintas platform (`image_picker` / `XFile.readAsBytes()`) maupun mekanisme fallback aman bila pengguna membatalkan galeri atau memilih file tidak valid/korup.

3. **Bug #4 (Controller disposal di sheet + absennya validasi email + copy misleading)**  
   Sheet Forgot Password pada `LoginScreen` belum memakai `StatefulWidget` untuk mengelola siklus hidup `_emailController`, belum memasang validator `Form` untuk email kosong/tidak valid, langsung menutup modal dengan copy simulasi yang belum membedakan frontend simulation vs email terkirim, dan menimbulkan `TextEditingController was used after being disposed` saat keluar.

4. **Temuan Tambahan (`errorMaxLines` pada `FlowinTextField`)**  
   `InputDecoration` pada `FlowinTextField` tidak mengatur `errorMaxLines`, sehingga teks pesan error 50 karakter (`'Enter a valid email address (e.g. name@flowin.id)'`) terpotong di layar sempit.

---

## 4. File yang Diubah

### File Baru
- `lib/core/services/profile_photo_picker.dart` — hasil picker (`PhotoPickResult`: `PhotoPickSuccess`, `PhotoPickCancelled`, `PhotoPickFailure`), validator binary (`validateProfilePhotoBytes`, batas `5 MB`, cek ekstensi & magic signature PNG/JPEG/GIF/WebP/BMP), antarmuka `ProfilePhotoPicker`, dan `ImagePickerProfilePhotoPicker`.
- `lib/core/utils/flowin_validators.dart` — validator terpusat `FlowinValidators.email` dan `FlowinValidators.requiredText`.
- `lib/shared/widgets/flowin_user_avatar.dart` — komponen `FlowinUserAvatar` berbasis `Image.memory(..., gaplessPlayback: true, errorBuilder: _DefaultAvatarCrest)` dengan badge kamera dan state loading.
- `lib/widgets/delivery_address_editor_sheet.dart` — `DeliveryAddressEditorSheet` (`StatefulWidget`) dengan `show(BuildContext)`.
- `lib/widgets/add_payment_method_sheet.dart` — `AddPaymentMethodSheet` (`StatefulWidget`) dengan `show(BuildContext, {String submitLabel})`.
- `test/bug_fixes_test.dart` — 9 automated unit/widget test untuk Bug #1–#4 dan sinkronisasi state lintas layar.

### File Dimodifikasi
- `lib/state/flowin_app_state.dart` — menambah konstruktor opsional `FlowinAppState({ProfilePhotoPicker? photoPicker})`, `_profilePhotoBytes`, `profilePhotoBytes`, `hasProfilePhoto`, `updateProfilePhoto`, `clearProfilePhoto`, `pickProfilePhoto`, `_customPaymentCounter`, `_resolvePaymentIcon`, serta validasi/normalisasi `addPaymentMethod` dan `updateDeliveryAddress`.
- `lib/widgets/profile_header_card.dart` — mengganti avatar hardcoded dengan `FlowinUserAvatar(photoBytes: appState?.profilePhotoBytes, size: 56)`.
- `lib/screens/cart/cart_screen.dart` — mengalihkan edit alamat ke `DeliveryAddressEditorSheet.show(context)`.
- `lib/screens/checkout/checkout_screen.dart` — mengalihkan edit alamat ke `DeliveryAddressEditorSheet.show(context)` dan tambah pembayaran ke `AddPaymentMethodSheet.show(context, submitLabel: 'Save & Select')`.
- `lib/screens/subscription/subscription_checkout_screen.dart` — mengalihkan edit alamat ke `DeliveryAddressEditorSheet.show(context)`.
- `lib/screens/profile/payment_methods_screen.dart` — mengalihkan tambah metode pembayaran ke `AddPaymentMethodSheet.show(context, submitLabel: 'Save Payment Method')` dan menambah guard `if (!context.mounted) return;` di `_openTopUpSheet`.
- `lib/screens/profile/personal_information_screen.dart` — menambah `_openPhotoOptionsSheet` (`Choose from Gallery` + `Remove Current Photo`), `_pickProfilePhoto`, `_removeProfilePhoto`, avatar interaktif `FlowinUserAvatar`, serta aksi **Edit Photo** dan **Remove**.
- `lib/screens/auth/login_screen.dart` — mengganti sheet Forgot Password dengan `_ForgotPasswordSheet` (`StatefulWidget`), validasi `FlowinValidators.email`, notice demo frontend, tampilan konfirmasi dalam sheet **Recovery Simulation Completed**, dan tombol **Back to Login** yang menutup sheet dengan aman + toast info.
- `lib/shared/widgets/flowin_text_field.dart` — menambah `errorMaxLines: 2` pada `InputDecoration`.
- `pubspec.yaml`, `pubspec.lock`, serta file registrant plugin generated Flutter (`linux/flutter/generated_plugin_registrant.cc`, `linux/flutter/generated_plugins.cmake`, `macos/Flutter/GeneratedPluginRegistrant.swift`, `windows/flutter/generated_plugin_registrant.cc`, `windows/flutter/generated_plugins.cmake`) — akibat penambahan package `image_picker: ^1.2.4`.

---

## 5. Solusi yang Diterapkan

- **Bug #1 (Delivery Address)**: Mengekstrak `DeliveryAddressEditorSheet` sebagai `StatefulWidget` terpadu untuk `CartScreen`, `CheckoutScreen`, dan `SubscriptionCheckoutScreen`. `_titleController` dan `_addressController` di-dispose di `State.dispose()` (hanya setelah route selesai exit), input divalidasi dengan `FlowinValidators.requiredText`, `appState.updateDeliveryAddress(...)` dipanggil sebelum `Navigator.of(context).pop(true)`, dan `FlowinToast` ditampilkan pada `context.mounted` setelah `await showModalBottomSheet`. Perilaku menyimpan tanpa mengubah isi tetap menampilkan toast `Address Updated` tanpa error. Pencarian `whenComplete` di seluruh `lib/` memastikan tidak ada lagi pola disposal prematur tersisa.
- **Bug #2 (Add Payment Method)**: Mengekstrak `AddPaymentMethodSheet` sebagai `StatefulWidget` untuk `PaymentMethodsScreen` dan `CheckoutScreen`. Kedua field (**Method Name** minimal 2 karakter dan **Account / Reference Note** minimal 3 karakter) divalidasi inline disertai banner catatan demo (`Demo checkout only — no real card numbers or billing details required.`). `FlowinAppState.addPaymentMethod` membersihkan spasi input, mengabaikan label kosong, menetapkan ID unik (`custom_n`), memetakan ikon via `_resolvePaymentIcon`, memilih metode baru (`_selectedPaymentId = id`), lalu menutup modal sebelum memicu toast `Payment Method Saved`.
- **Bug #3 (Profile Photo Upload)**: Menambahkan `ProfilePhotoPicker` dengan implementasi default `ImagePickerProfilePhotoPicker` (kompatibel Android & Web melalui `XFile.readAsBytes()` tanpa meminta permission storage manifest berlebih pada Android Photo Picker modern). Bytes divalidasi (`<= 5 MB`, ekstensi `.jpg/.jpeg/.png/.webp/.gif/.bmp`, dan magic bytes PNG/JPEG/GIF/WebP/BMP). `PersonalInformationScreen` membuka bottom sheet **Update Profile Photo** (**Choose from Gallery** / **Remove Current Photo**) saat avatar atau **Edit Photo** diketuk; pembatalan pengguna (`PhotoPickCancelled`) mempertahankan foto sebelumnya tanpa pesan error, kegagalan (`PhotoPickFailure`) menjaga foto lama dan menampilkan toast error, dan perubahan foto tersinkronisasi instan ke `ProfileHeaderCard` via `FlowinScope`.
- **Bug #4 (Forgot Password)**: Mengganti implementasi modal menjadi `_ForgotPasswordSheet` (`StatefulWidget`) dengan `GlobalKey<FormState>`, `FlowinValidators.email`, dan notice eksplisit `'Frontend demo — no real recovery email is sent.'`. Email kosong atau tidak valid ditolak inline (dibungkus rapi oleh `errorMaxLines: 2` di `FlowinTextField`). Email valid memicu transisi ke view konfirmasi `'Recovery Simulation Completed'` (`'Recovery link simulation completed for <email>. If this were a connected service, a reset email would be sent to your address.'`) dengan tombol **Back to Login** yang memanggil `Navigator.of(context).pop(true)`, men-dispose `_emailController` di `State.dispose()` sesudah animasi keluar selesai, lalu menampilkan toast informatif `'Returned cleanly to sign in.'` tanpa error maupun panggilan jaringan eksternal.

---

## 6. Dependency Baru dan Alasannya

- `image_picker: ^1.2.4` (menarik `image_picker_android 0.8.13+17`, `image_picker_for_web 3.1.1`, dan platform interface terkait)
  - **Alasan**: Kebutuhan resmi lintas platform Android dan Flutter Web untuk membuka pemilih galeri perangkat secara native (`PickVisualMedia`/Photo Picker di Android dan HTML `<input type="file">` di Web) serta membaca hasil gambar ke `Uint8List` melalui `XFile.readAsBytes()` untuk `Image.memory`. Tidak ada backend, database, atau package tambahan lain yang ditambahkan.

---

## 7. Test yang Ditambahkan

Ditambahkan 9 test di `test/bug_fixes_test.dart`:
1. `Bug #1` — `Cart edit delivery address updates state after editing text with zero exceptions` (edit teks label & alamat -> save -> verifikasi state berubah, toast tampil, tanpa disposal error).
2. `Bug #1` — `Cart edit delivery address with unchanged values still shows update toast safely` (save tanpa perubahan -> state utuh, toast tampil).
3. `Bug #1` — `Cart edit delivery address rejects empty fields and keeps sheet open` (validasi kosong inline).
4. `Bug #1` — `Checkout & SubscriptionCheckout edit address sync state safely without controller disposal errors` (lintas layar Checkout & Subscription Checkout).
5. `Bug #2` — `PaymentMethods validates incomplete fields, saves new method, and updates UI & selection` (validasi kosong, simpan metode baru, cek seleksi & pindah pilihan).
6. `Bug #2` — `Checkout Add New payment method adds, selects, persists, and renders cleanly` (tambah dari Checkout, sinkron saat berpindah ke `PaymentMethodsScreen`).
7. `Bug #3` — `validateProfilePhotoBytes rejects empty, oversize, unsupported, and corrupt bytes` (unit test batas `> 5 MB`, format `.pdf`, bytes rusak, bytes kosong, dan PNG valid).
8. `Bug #3` — `PersonalInformation uploads, previews, syncs to ProfileHeaderCard, handles cancel & errors, and removes safely` (pakai `_FakePhotoPicker`, verifikasi crest default -> upload PNG valid -> cancel tetap mempertahankan foto -> error format mempertahankan foto + menampilkan error -> sinkron ke `ProfileScreen` / `ProfileHeaderCard` -> **Remove** memulihkan crest default).
9. `Bug #4` — `Forgot Password validates empty & malformed emails, then simulates recovery cleanly back to Login` (tolak spasi kosong, tolak `invalid-email@domain`, terima `rifan.user@flowin.id`, verifikasi layar **Recovery Simulation Completed**, tap **Back to Login** tanpa controller error, verifikasi toast di `LoginScreen`).

---

## 8. Hasil `flutter analyze`

Dijalankan setelah seluruh perubahan kode selesai (`2026-11-11`):
- Command: `flutter analyze`
- Output: `Analyzing flowin...` -> `No issues found! (ran in 11.7s)`
- Status: **PASS (0 errors, 0 warnings, 0 lints)**

---

## 9. Hasil `flutter test`

Dijalankan penuh secara sekuensial (`flutter test --reporter expanded --concurrency=1`) setelah seluruh edit final:
- `test/bug_fixes_test.dart`: **9/9 PASS**
- `test/navigation_and_state_test.dart`: **5/5 PASS** (`FlowinAppState business logic`, `Onboarding -> Login -> Register -> RegisterSuccess`, `Home -> ProductDetail -> Cart -> Checkout -> Payment`, `Tracking -> RatingReview -> ReviewSuccess`, `CancelOrder, Profile edits, Payment top up & Subscription flow`)
- `test/widget_test.dart`: **1/1 PASS** (`FlowinApp renders onboarding screen and state initializes cleanly`)
- Total: **`00:25 +15: All tests passed!`** (0 failures, 0 skipped)

---

## 10. Hasil Build Android dan Web

1. **Flutter Web (`flutter build web --no-wasm-dry-run`)**
   - Status: **PASS** (exit code `0`, `Compiling lib\main.dart for the Web... 47.7s`, `√ Built build\web`)
2. **Android Debug APK (`flutter build apk --debug`)**
   - Status: **PASS** (exit code `0`, `Running Gradle task 'assembleDebug'... 137.0s`, `√ Built build\app\outputs\flutter-apk\app-debug.apk`).
   - Catatan Gradle: muncul peringatan non-fatal incremental cache Kotlin lintas drive (`C:\` Pub Cache vs `E:\` project root pada `image_picker_android`) yang otomatis diselesaikan oleh compiler Kotlin dengan exit code `0`.

---

## 11. Hasil Pengujian Manual / Interaktif

Pengujian end-to-end dijalankan pada build terbaru untuk dua platform:

### A. Flutter Web (Playwright Headless Chromium, viewport `390x844` @2x)
- **Bug #4 (Forgot Password)**: Menguji input kosong (`Please enter your email address`), format salah `invalid@domain` (`Enter a valid email address (e.g. name@flowin.id)` terbungkus rapi 2 baris tanpa elipsis), input valid `qa.web@flowin.id` (`Recovery Simulation Completed`), dan tombol **Back to Login** + toast `Returned cleanly to sign in.`.
- **Bug #1 (Delivery Address)**: Save tanpa edit menampilkan `Address Updated`; edit label `HQ • Ocean Tower` & alamat `Jl. Thamrin No. 9, Central Jakarta` memperbarui Cart & Checkout tanpa error.
- **Bug #2 (Add Payment Method)**: Submit kosong menampilkan validasi kedua field; input `GoPay Wallet` / `+62 812 5555 1111` menambah metode baru, memilihnya di Checkout, menampilkan toast `Payment Method Saved`, dan tetap tersinkron saat berpindah ke Profile/Personal Info (`Manage Payment Methods: GoPay Wallet`).
- **Bug #3 (Profile Photo)**: Ketuk **Edit Photo** -> **Choose from Gallery** -> pilih file PNG (`64x64`) -> avatar ter-render di `PersonalInformationScreen`, muncul aksi **Edit Photo** & **Remove** + toast `Profile Photo Updated`, lalu kembali ke tab `Profile` memverifikasi `ProfileHeaderCard` langsung menampilkan avatar baru.
- Console & page errors: **`WEB CONSOLE ERRORS (0): []`**, **`WEB PAGE ERRORS (0): []`**.

### B. Android Perangkat Fisik (`vivo 1935`, serial `fb4262f2`, ADB + uiautomator + logcat)
- APK debug terpasang dan dijalankan (`com.example.flowin/.MainActivity`).
- **Bug #4**: Buka **Forgot Password?**, ketuk **Send Recovery Link** (`alex.morgan@flowin.id`), masuk ke konfirmasi **Recovery Simulation Completed**, ketuk **Back to Login** -> kembali ke Login dengan toast bersih.
- **Bug #1**: Edit Delivery Address di `CartScreen` (`+ Tower B`), tap **Save Address** -> toast `Address Updated` tampil, alamat baru sinkron sampai halaman `CheckoutScreen`.
- **Bug #2**: Buka **Add New** di Checkout, uji validasi kosong (`Method name cannot be empty`, `Account note cannot be empty`), lalu isi `GoPay Vivo` / `Demo 8899` dan tap **Save & Select** -> toast `Payment Method Saved`, metode baru terpilih aktif di Checkout.
- **Bug #3**: Masuk ke `Profile` -> `Personal Info` (alamat sinkron tampil di form), ketuk **Edit Photo** -> **Choose from Gallery** -> pemilih galeri/DocumentsUI Android terbuka bersih, tekan Back untuk simulasi cancel -> kembali ke `Personal Info` dengan state aman dan tanpa error.
- Logcat (`adb logcat -d -s flutter:E AndroidRuntime:E`): **0 exception / 0 fatal error**.

---

## 12. Bug yang Masih Tersisa

- **Tidak ada** bug fungsional atau lifecycle yang tersisa pada keempat area target maupun alur regresi inti.
- Catatan cakupan lingkungan:
  - Pengujian upload gambar valid penuh dengan file picker dilakukan via Chromium Playwright file chooser pada Web dan via `_FakePhotoPicker` serta unit test bytes pada suite otomatis; di perangkat fisik Android `vivo 1935`, peluncuran pemilih galeri sistem dan pembatalan (`Cancel`) diverifikasi langsung melalui ADB, sementara pemilihan file gambar aktual di dalam sistem galeri OS berada di luar sandbox kontrol ADB tanpa file foto dummy di galeri internal perangkat.
  - Pada pengujian otomasi Web berbasis aksesibilitas Flutter (`flt-semantics`), pengisian teks ulang sesudah munculnya pesan validasi memerlukan interaksi langsung ke `flt-text-editing-host` (perilaku normal browser tanpa overlay screen reader), sedangkan pada mode pengguna browser normal validasi dan pengetikan ulang berfungsi penuh.

---

## 13. Commit Hash dan Status Git

- Branch aktif: `rifan` (`main` tidak disentuh)
- Commit perbaikan & test: `8bec7d1` (`8bec7d1cc0951fdb79ca10a0c4d0833bafe8f05f`) — `fix(hardening): resolve modal controller lifecycle, payment, photo upload, and recovery bugs` (22 files changed)
- Stash: `stash@{0}: WIP on main: 5dbc631 Merge pull request #10 from Rifan214/bintang` tetap utuh dan tidak diubah/dihapus
- Push: Tidak ada push atau force push ke remote
- Laporan ini (`bug_fix_report.md`) ditulis di root repository setelah seluruh verifikasi selesai.
