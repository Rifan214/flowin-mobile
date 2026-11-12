# Flowin — UI/UX Consistency, Navigation & Microinteraction Polish Report

## 1. Executive Summary

Ketujuh temuan konsistensi UI/UX, arsitektur shared header, hardening navigasi alur pesanan, dan polish microinteraction pada aplikasi **Flowin** (design system *Ocean Mist & Deep Current*, state management `FlowinAppState` + `FlowinScope`) telah diinvestigasi, diaudit secara menyeluruh, diperbaiki di root cause-nya, dan diverifikasi di seluruh jalur automated test, build target **Flutter Web** dan **Android (APK)**, serta QA interaktif lintas platform.

Ringkasan hasil utama:
- **Arsitektur Header Terpadu (`FlowinHeader`)**: Diperbarui dengan konfigurasi deklaratif (`showNotification`, `showBackButton`, `leading`, `notificationCount`) dan layout `NavigationToolbar(centerMiddle: true, middleSpacing: 12)` di dalam `SizedBox(height: 44)`, sehingga judul selalu simetris di tengah tanpa meninggalkan spacer kosong (`SizedBox` tak terpakai) saat aksi kanan ditiadakan.
- **Konsistensi Tab Utama (`Home`, `Orders`, `Cart`, `Profile`)**: Header `HomeScreen` dipisahkan keluar dari `CustomScrollView` agar tetap *pinned* seperti `OrdersScreen` dan `ProfileScreen`. `CartScreen` mengembalikan tombol Notification di `FlowinHeader` dan memindahkan tombol `Clear` ke dalam konten di samping `Basket Items`.
- **Pembersihan Header Sub-Layar**: Ikon kunci di `CheckoutScreen` dan ikon tanda tanya di `RegisterScreen` dihapus dengan `showNotification: false`, sementara `SubscriptionCheckoutScreen` tetap dipertahankan tidak diubah sesuai aturan.
- **Hardening Navigasi Back (`LiveDeliveryTrackingScreen` & `RatingReviewScreen`)**: Navigasi balik (baik tombol Back header maupun system/hardware Back melalui `PopScope`) dari `LiveDeliveryTrackingScreen` diarahkan langsung ke tab `Orders` (`MainNavigationScreen(initialIndex: 1)`), sedangkan dari `RatingReviewScreen` maupun `ReviewSuccessScreen` diarahkan ke `Home` (`MainNavigationScreen()`). `PaymentConfirmationScreen` kini memakai `Navigator.pushReplacement` saat menuju `LiveDeliveryTrackingScreen`.
- **Microinteraction & Konfirmasi Destruktif**: Ditambahkan `FlowinFavoriteButton` (press-scale + spring pop `1.32` + `_FavoriteBurstPainter` 8 partikel/ripple saat menyimpan, serta transisi reverse tenang tanpa burst saat un-save) di `ProductCard` dan `ProductDetailScreen`, serta dialog konfirmasi destruktif `showFlowinConfirmDialog` sebelum `clearCart()` di `CartScreen`.
- **Verifikasi Lintas Platform**: Seluruh check lulus pasca-edit terakhir: `flutter analyze` (`No issues found!`), `flutter test` (`+26: All tests passed!`), `flutter build web --no-wasm-dry-run`, `flutter build apk --debug`, Playwright Web QA (`0` console/page error, mobile & desktop `1280x800`), dan Android device QA pada **vivo 1935** (`fb4262f2`, `0` error pada `logcat`).

---

## 2. Masalah yang Ditemukan

1. **Issue #1 — Home Header Scroll Behavior**: Header pada `HomeScreen` ikut terscroll bersama konten karena ditempatkan di dalam `SliverToBoxAdapter` di dalam `CustomScrollView`, berbeda dari `OrdersScreen` dan `ProfileScreen` yang menahan header tetap di bagian atas.
2. **Issue #2 — Cart Header Inconsistency**: `CartScreen` menimpa slot `actions` pada `FlowinHeader` dengan tombol `Clear` (atau `SizedBox`), sehingga tombol Notification hilang dari header tab `Cart` dan posisi aksi di area header menjadi tidak konsisten dengan `Home`, `Orders`, dan `Profile`.
3. **Issue #3 — Unnecessary Header Icons di Checkout & Register + Placeholder Spacer**: `CheckoutScreen` menampilkan ikon kunci (`Icons.lock_outline_rounded`) dan `RegisterScreen` menampilkan ikon bantuan (`Icons.help_outline_rounded`) tanpa kebutuhan fungsional nyata. Di sisi lain, implementasi lama `FlowinHeader` yang memakai `Row` + spacer `SizedBox(width: 42)` berisiko menyisakan widget spacer kosong atau perataan judul tidak simetris saat tombol kanan dihilangkan.
4. **Issue #4 — Rating & Review Back Navigation**: Tombol Back header maupun system Back pada `RatingReviewScreen` (dan `ReviewSuccessScreen`) hanya melakukan `pop` biasa atau tidak terkunci ke tujuan eksplisit, padahal pasca-penyelesaian pengiriman pengguna seharusnya kembali ke layar `Home`, bukan kembali ke alur tracking/konfirmasi pesanan yang sudah selesai.
5. **Issue #5 — Live Tracking Back Navigation**: Dari `PaymentConfirmationScreen`, menekan **Track My Delivery** mendorong rute `LiveDeliveryTrackingScreen` di atas `PaymentConfirmationScreen`, sehingga menekan Back justru mengembalikan pengguna ke `PaymentConfirmationScreen` alih-alih ke tab `Orders`. Selain itu system Back pada `LiveDeliveryTrackingScreen` belum dikunci ke tab `Orders`.
6. **Issue #6 — Saved to Favorite Microinteraction**: Aksi toggle favorit pada `ProductCard` dan `ProductDetailScreen` belum memiliki microinteraction taktil yang ekspresif (press-scale, spring pop, partikel aqua/coral saat save, serta reverse yang tenang saat un-save) maupun sinkronisasi visual instan lintas layar.
7. **Issue #7 — Clear Cart Without Confirmation**: Tombol `Clear` pada `CartScreen` langsung menghapus seluruh isi keranjang melalui `appState.clearCart()` tanpa dialog konfirmasi destruktif, sehingga rentan tertekan secara tidak sengaja.

---

## 3. Root Cause Setiap Masalah

1. **Issue #1**: Pada `lib/screens/home/home_screen.dart`, `FlowinHeader` dibungkus sebagai sliver pertama (`SliverToBoxAdapter`) di dalam `CustomScrollView`, berbeda dari pola `Column(children: [FlowinHeader(...), Expanded(child: ...)])` yang digunakan `OrdersScreen` dan `ProfileScreen`.
2. **Issue #2**: `lib/screens/cart/cart_screen.dart` mengisi parameter `actions` di `FlowinHeader`, yang di `FlowinHeader` men-override perilaku default tombol Notification kanan menjadi widget custom `Clear`.
3. **Issue #3**:
   - `CheckoutScreen` meneruskan `rightIcon: Icon(Icons.lock_outline_rounded)` dan `RegisterScreen` meneruskan `rightIcon: Icon(Icons.help_outline_rounded)`.
   - `FlowinHeader` sebelumnya belum memiliki flag deklaratif `showNotification` yang benar-benar mengembalikan `trailingWidget = null` serta mengandalkan `SizedBox(width: 42)` sebagai penyeimbang `Row`, bukan `NavigationToolbar(centerMiddle: true)` di dalam `SizedBox(height: 44)`. (Catatan: membungkus `NavigationToolbar` dalam `ConstrainedBox(minHeight: 42)` tanpa `maxHeight` menyebabkan unbounded height crash di dalam `Column`, sehingga tinggi dibatasi dengan `SizedBox(height: 44)`).
4. **Issue #4 & #5**:
   - `PaymentConfirmationScreen` memakai `Navigator.push` alih-alih `Navigator.pushReplacement` ketika membuka `LiveDeliveryTrackingScreen`.
   - `LiveDeliveryTrackingScreen`, `RatingReviewScreen`, dan `ReviewSuccessScreen` belum memakai `PopScope(canPop: false, onPopInvokedWithResult: ...)` maupun `onLeftIconPressed` yang mereset root stack ke `MainNavigationScreen(initialIndex: 1)` atau `MainNavigationScreen()`.
5. **Issue #6**: Tombol favorit sebelumnya bersifat statis tanpa `AnimationController` terkoordinasi untuk membedakan fase *add* (press -> spring overshoot -> particle burst & ripple) dan fase *remove* (reverse tenang tanpa burst) serta pengecekan `FlowinMotion.isReduced(context)`.
6. **Issue #7**: `CartScreen` langsung mengeksekusi mutasi destruktif `appState.clearCart()` pada `onPressed` tanpa modal konfirmasi dua langkah yang konsisten dengan bahasa desain aplikasi.

---

## 4. Audit Arsitektur Shared Header

Seluruh pemanggilan `FlowinHeader` di `lib/screens/` telah diaudit untuk memastikan konsistensi struktural dan tidak ada duplikasi komponen header baru:

| Layar / File | Tipe Layar | Konfigurasi `FlowinHeader` | Trailing Saat Ini | Status |
|---|---|---|---|---|
| `HomeScreen` (`lib/screens/home/home_screen.dart`) | Primary Tab 0 | `showBrandLogo: true, showNotification: true` | Notification + badge | Diperbaiki (Pinned) |
| `OrdersScreen` (`lib/screens/orders/orders_screen.dart`) | Primary Tab 1 | `title: 'Orders', showBackButton: false, showNotification: true` | Notification + badge | Terstandardisasi |
| `CartScreen` (`lib/screens/cart/cart_screen.dart`) | Primary Tab 2 | `title: 'My Cart', showBackButton: false, showNotification: true` | Notification + badge | Diperbaiki |
| `ProfileScreen` (`lib/screens/profile/profile_screen.dart`) | Primary Tab 3 | `title: 'Profile', showBackButton: false, showNotification: true` | Notification + badge | Terstandardisasi |
| `CheckoutScreen` (`lib/screens/checkout/checkout_screen.dart`) | Sub-screen | `title: 'Checkout', showNotification: false` | `null` (0 spacer) | Diperbaiki |
| `RegisterScreen` (`lib/screens/auth/register_screen.dart`) | Sub-screen | `title: 'Create Account', showNotification: false` | `null` (0 spacer) | Diperbaiki |
| `LiveDeliveryTrackingScreen` (`lib/screens/tracking/live_delivery_tracking_screen.dart`) | Tracking | `title: 'Live Tracking', showBackButton: true, showNotification: false, onLeftIconPressed: () => _backToOrders(context)` | `null` (0 spacer) | Diperbaiki |
| `RatingReviewScreen` (`lib/screens/review/rating_review_screen.dart`) | Review | `title: 'Rate Delivery', showBackButton: true, showNotification: false, onLeftIconPressed: () => _backToHome(context)` | `null` (0 spacer) | Diperbaiki |
| `ProductDetailScreen` (`lib/screens/detail/product_detail_screen.dart`) | Detail | `title: 'Product Details', actions: [FlowinFavoriteButton(...)]` | `FlowinFavoriteButton` | Diupgrade |
| `NotificationScreen` (`lib/screens/notification/notification_screen.dart`) | Utility | `title: 'Notifications', actions: [TextButton(...)]` | Conditional `TextButton` | Tetap |
| `CancelOrderScreen`, `PaymentMethodsScreen`, `PersonalInformationScreen`, `SubscriptionScreen`, `SubscriptionPaymentScreen` | Sub-screen | `rightIcon: SizedBox(width: 42)` | Otomatis `null` via `!showNotification \|\| rightIcon is SizedBox` | Terkompatibelkan |
| `OrderCancelledScreen` (`lib/screens/orders/order_cancelled_screen.dart`) | Confirmation | `leftIcon: SizedBox(width: 42), rightIcon: SizedBox(width: 42)` | `null` (`leading == null` & `trailing == null`) | Terkompatibelkan |
| `SubscriptionCheckoutScreen` (`lib/screens/subscription/subscription_checkout_screen.dart`) | Plan Checkout | `title: 'Plan Checkout', rightIcon: Icon(Icons.help_outline_rounded)` | Help icon | **Tidak diubah (Aturan #12)** |

Mekanisme kunci pada `lib/widgets/flowin_header.dart`:
- `trailingWidget` diset `null` jika `!showNotification || rightIcon is SizedBox` (saat `actions == null`).
- `leadingWidget` diset `null` jika `leftIcon is SizedBox`.
- Pada mode non-brand (`!useBrandHeader`), header memakai `NavigationToolbar(centerMiddle: true, middleSpacing: 12, leading: leadingWidget, middle: Text(...), trailing: trailingWidget)` di dalam `SizedBox(height: 44)` sehingga tidak diperlukan widget `SizedBox(width: 42)` kosong hanya untuk menyeimbangkan judul di tengah.

---

## 5. Perubahan pada Home Header (Issue #1)

Pada `lib/screens/home/home_screen.dart`:
- `SafeArea` kini merender `Column` berisi:
  1. `const FlowinHeader(showBrandLogo: true, showNotification: true)` secara statis di posisi atas.
  2. `Expanded(child: CustomScrollView(...))` untuk greeting `Good Morning, <firstName>`, location subtitle, `Live Order` chip, `SearchBox`, filter chip strip, `Fresh Gallon Catalog`, dan banner `Smart Refill Pass`.
- Akibatnya saat halaman digulir ke bawah pada viewport sempit (`360dp`), standar (`390dp`), maupun desktop (`1280dp`), logo *flowin PURE HYDRATION* dan tombol Notification tetap menempel (*pinned*) di atas konten tanpa overlap dan tanpa menggeser layout grid katalog.

---

## 6. Perubahan pada Cart Header & Clear Action (Issue #2 & #7)

Pada `lib/screens/cart/cart_screen.dart`:
- Header diganti menjadi `const FlowinHeader(title: 'My Cart', showBackButton: false, showNotification: true)` sehingga identik dengan pola `OrdersScreen` dan `ProfileScreen`.
- Tombol `Clear` (`TextButton.icon` dengan `Icons.delete_sweep_rounded` berwarna `FlowinColors.danger`) ditempatkan di dalam area konten di baris tajuk `Basket Items (${appState.cartItemCount})`, dan hanya muncul ketika `items.isNotEmpty`.
- Menekan tombol `Clear` memanggil `_confirmClearCart(context, appState)` yang menjaga kondisi kosong (`if (appState.cartItems.isEmpty) return;`), membuka `showFlowinConfirmDialog`, dan hanya mengeksekusi `appState.clearCart()` serta menampilkan `FlowinToast` `'Cart Cleared'` jika pengguna mengonfirmasi **Clear Cart**.

---

## 7. Pembersihan Header Checkout & Register (Issue #3)

- `lib/screens/checkout/checkout_screen.dart`: Parameter `rightIcon: Icon(Icons.lock_outline_rounded)` diganti dengan `showNotification: false`.
- `lib/screens/auth/register_screen.dart`: Parameter `rightIcon: Icon(Icons.help_outline_rounded)` diganti dengan `showNotification: false`.
- Verifikasi widget test (`test/ui_ux_polish_test.dart`) memastikan pada kedua layar tersebut `toolbar.trailing == null`, jumlah child widget spacer kosong nol, tombol Back di sisi kiri tetap berfungsi, dan judul `'Checkout'` serta `'Create Account'` tetap rata tengah.

---

## 8. Perbaikan Alur Back Rating & Review (Issue #4)

- `lib/screens/review/rating_review_screen.dart`:
  - Menambahkan helper `_backToHome(BuildContext context)` yang memanggil `Navigator.pushAndRemoveUntil(context, FlowinPageRoute.fadeScale(const MainNavigationScreen()), (route) => false)`.
  - Membungkus `Scaffold` dengan `PopScope(canPop: false, onPopInvokedWithResult: (didPop, _) { if (!didPop) _backToHome(context); })` untuk menangkap system Back Android / browser Back.
  - Mengonfigurasi `FlowinHeader(title: 'Rate Delivery', showBackButton: true, showNotification: false, onLeftIconPressed: () => _backToHome(context))`.
- `lib/screens/review/review_success_screen.dart`:
  - Membungkus `Scaffold` dengan `PopScope(canPop: false, ...)` menggunakan helper `_backToHome(context)` agar system Back dari layar sukses ulasan juga kembali ke `Home`, bukan ke halaman sebelumnya yang sudah selesai.

---

## 9. Perbaikan Alur Back Live Tracking (Issue #5)

- `lib/screens/payment/payment_confirmation_screen.dart`:
  - Mengubah aksi tombol **Track My Delivery** dari `Navigator.push` menjadi `Navigator.pushReplacement`, sehingga `PaymentConfirmationScreen` digantikan oleh `LiveDeliveryTrackingScreen` dan tidak lagi tertinggal di back stack.
- `lib/screens/tracking/live_delivery_tracking_screen.dart`:
  - Menambahkan helper `_backToOrders(BuildContext context)` yang memanggil `Navigator.pushAndRemoveUntil(context, FlowinPageRoute.fadeScale(const MainNavigationScreen(initialIndex: 1)), (route) => false)`.
  - Membungkus `Scaffold` dengan `PopScope(canPop: false, onPopInvokedWithResult: (didPop, _) { if (!didPop) _backToOrders(context); })` sehingga system Back di Android selalu mendarat bersih di tab `Orders` (`initialIndex: 1`), baik ketika `LiveDeliveryTrackingScreen` dibuka dari `OrdersScreen`, `HomeScreen` (`Live Order`), maupun `PaymentConfirmationScreen`.
  - Mengonfigurasi `FlowinHeader(title: 'Live Tracking', showBackButton: true, showNotification: false, onLeftIconPressed: () => _backToOrders(context))`.

---

## 10. Implementasi Animasi Favorite (Issue #6)

Komponen baru `lib/shared/widgets/flowin_favorite_button.dart` (`FlowinFavoriteButton`, `StatefulWidget` dengan `SingleTickerProviderStateMixin`):
- **Single Controller Lifecycle**: Menggunakan satu `AnimationController` (`duration: 500ms`, `reverseDuration: 220ms`) yang selalu di-dispose pada `State.dispose()`.
- **Tactile Press Feedback**: Saat disentuh (`onTapDown` / `onTapUp` / `onTapCancel`), kontainer dan ikon mengecil halus ke `0.84` dalam durasi `90ms` (saat reduced-motion nonaktif) serta memicu `AppHaptics.medium()` ketika menambahkan favorit atau `AppHaptics.light()` saat menghapus.
- **Add-to-Favorite Choreography**: Ketika `isFavorite` berubah `false -> true`, `_addScaleSequence` (`TweenSequence`: `0.92 -> 0.78 -> 1.32` dengan `FlowinCurves.spring` -> `0.95 -> 1.0`) berjalan beriringan dengan `_FavoriteBurstPainter` yang menggambar expanding aqua ripple ring dan 8 partikel melingkar kecil (bergantian `FlowinColors.aqua` dan `FlowinColors.danger`).
- **Remove-from-Favorite Transition**: Ketika `isFavorite` berubah `true -> false`, `_celebrateBurst` diset `false` dan controller berjalan `reverse(from: 1.0)` selama `220ms` kembali ke ikon outline secara tenang tanpa animasi perayaan.
- **Aksesibilitas & Sinkronisasi State**: Menghormati `FlowinMotion.isReduced(context)` dengan loncatan nilai langsung tanpa overshoot/partikel. Terhubung penuh ke `FlowinAppState.isFavorite` dan `FlowinAppState.toggleFavorite` di `lib/widgets/product_card.dart` dan `lib/screens/detail/product_detail_screen.dart` disertai feedback `FlowinToast`.

---

## 11. Implementasi Dialog Konfirmasi Clear Cart (Issue #7)

Komponen baru `lib/shared/widgets/flowin_confirm_dialog.dart` (`showFlowinConfirmDialog`):
- Memakai `showGeneralDialog<bool>` dengan barrier redup `FlowinColors.ink.withValues(alpha: 0.42)`, transisi `240ms` fade + scale ringan (dan `Duration.zero` saat `FlowinMotion.isReduced(context)` aktif), serta kontainer permukaan *Ocean Mist & Deep Current* (`FlowinColors.surface`, `borderRadius: 24`, lebar maksimum `380px`).
- Menampilkan badge ikon lingkaran (`FlowinColors.dangerSoft` + `Icons.delete_sweep_rounded` untuk aksi destruktif), judul `'Clear Shopping Cart?'`, deskripsi `'Are you sure you want to remove all items from your cart? This action cannot be undone.'`, tombol sekunder `'Cancel'` (`FlowinButtonVariant.outlined`, mengembalikan `false`), dan tombol primer destruktif `'Clear Cart'` (`FlowinButtonVariant.danger`, mengembalikan `true`).
- Pada `CartScreen._confirmClearCart`, pembatalan (`Cancel` atau tap barrier) mempertahankan seluruh item keranjang, nominal subtotal/total, dan badge navigasi; konfirmasi (`Clear Cart`) memanggil `appState.clearCart()`, memperbarui total/badge menjadi 0, merender empty state `'Your Basket is Empty'`, dan menampilkan `FlowinToast` `'Cart Cleared'`.

---

## 12. Daftar File yang Diubah / Ditambahkan

### File Baru
- `lib/shared/widgets/flowin_confirm_dialog.dart` — helper dialog konfirmasi destruktif `showFlowinConfirmDialog` bertema *Ocean Mist & Deep Current*.
- `lib/shared/widgets/flowin_favorite_button.dart` — tombol favorit interaktif `FlowinFavoriteButton` dan `_FavoriteBurstPainter`.
- `test/ui_ux_polish_test.dart` — 11 automated widget test untuk seluruh perbaikan Issue #1–#7 dan pengujian responsif `360dp`, `390dp`, dan `1280dp`.
- `ui_ux_polish_report.md` — laporan dokumentasi dan verifikasi UI/UX polish ini.

### File Dimodifikasi
- `lib/widgets/flowin_header.dart` — dukungan deklaratif `showNotification`, `leading`, `notificationCount`, `NavigationToolbar(centerMiddle: true)` dalam `SizedBox(height: 44)`, dan eliminasi spacer kosong untuk `rightIcon is SizedBox` / `!showNotification`.
- `lib/screens/home/home_screen.dart` — memisahkan `FlowinHeader` keluar dari `CustomScrollView` ke posisi teratas `Column` agar *pinned* saat scroll.
- `lib/screens/orders/orders_screen.dart` — eksplisit menetapkan `showBackButton: false, showNotification: true` pada `FlowinHeader`.
- `lib/screens/profile/profile_screen.dart` — eksplisit menetapkan `showBackButton: false, showNotification: true` pada `FlowinHeader`.
- `lib/screens/cart/cart_screen.dart` — menyeragamkan `FlowinHeader(title: 'My Cart', showBackButton: false, showNotification: true)`, memindahkan tombol `Clear` ke header konten `Basket Items`, dan menambahkan konfirmasi `_confirmClearCart` via `showFlowinConfirmDialog`.
- `lib/screens/checkout/checkout_screen.dart` — menghapus ikon gembok header dengan `showNotification: false`.
- `lib/screens/auth/register_screen.dart` — menghapus ikon `?` header dengan `showNotification: false`.
- `lib/screens/payment/payment_confirmation_screen.dart` — mengubah `'Track My Delivery'` menjadi `Navigator.pushReplacement`.
- `lib/screens/tracking/live_delivery_tracking_screen.dart` — menambah `_backToOrders` ke tab `Orders`, `PopScope(canPop: false)`, dan konfigurasi eksplisit `FlowinHeader`.
- `lib/screens/review/rating_review_screen.dart` — menambah `_backToHome` ke `Home`, `PopScope(canPop: false)`, dan konfigurasi eksplisit `FlowinHeader`.
- `lib/screens/review/review_success_screen.dart` — menambah `_backToHome` dan `PopScope(canPop: false)` pada layar konfirmasi ulasan.
- `lib/widgets/product_card.dart` — mengganti tombol favorit dengan `FlowinFavoriteButton`.
- `lib/screens/detail/product_detail_screen.dart` — menggunakan `FlowinFavoriteButton` di slot `actions` `FlowinHeader` dan menyinkronkan ke `FlowinAppState.toggleFavorite`.

---

## 13. Hasil Automated Verification

| Check | Perintah | Hasil |
|---|---|---|
| Static Analysis | `flutter analyze` | **Lulus** — `No issues found! (ran in 7.2s)` |
| Full Automated Test Suite | `flutter test --reporter expanded --concurrency=1` | **Lulus (26/26 tests)** — `test/bug_fixes_test.dart` (9), `test/navigation_and_state_test.dart` (5), `test/ui_ux_polish_test.dart` (11), `test/widget_test.dart` (1) |
| Web Release Build | `flutter build web --no-wasm-dry-run` | **Lulus** — `√ Built build\web` (exit code `0`) |
| Android Debug APK Build | `flutter build apk --debug` | **Lulus** — `√ Built build\app\outputs\flutter-apk\app-debug.apk` (exit code `0`) |

Rincian skenario yang tercover di `test/ui_ux_polish_test.dart` (11 test):
1. Header Home tetap *pinned* saat scroll tanpa overflow di `360dp`.
2. Header Home tetap *pinned* saat scroll tanpa overflow di `390dp`.
3. Header Home tetap *pinned* saat scroll tanpa overflow di `1280dp`.
4. Konsistensi `FlowinHeader` + Notification pada seluruh tab utama (`Home`, `Orders`, `Cart`, `Profile`) serta posisi tombol `Clear` di konten Cart.
5. `CheckoutScreen` dan `RegisterScreen` meniadakan ikon trailing tanpa menyisakan trailing widget kosong di `NavigationToolbar`.
6. Alur `PaymentConfirmationScreen` -> `LiveDeliveryTrackingScreen` -> Back header mendarat di `Orders`.
7. Alur `Orders` -> `LiveDeliveryTrackingScreen` -> system Back (`handlePopRoute`) mendarat di `Orders`.
8. Alur `PaymentConfirmationScreen` -> `LiveDeliveryTrackingScreen` -> `RatingReviewScreen` -> header/system Back mendarat di `Home`.
9. Favorite toggle dari `Home` dan `ProductDetailScreen` menganimasikan spring pop, reverse outline, dan tetap tersinkron di `FlowinAppState`.
10. `FlowinFavoriteButton` menghormati `disableAnimations: true`.
11. Dialog konfirmasi Clear Cart (`Cancel` mempertahankan basket; `Clear Cart` mengosongkan keranjang, subtotal/total, dan badge navigasi).

---

## 14. Hasil Interactive Testing (Flutter Web & Android `vivo 1935`)

### A. Flutter Web (Playwright Chromium, `390x844` Mobile & `1280x800` Desktop)
- **Skrip QA**: `qa_ui_ux_polish_web.py` berjalan terhadap hasil `flutter build web` pada port lokal `8125`.
- **Hasil Runtime**: Exit code `0`, `WEB CONSOLE ERRORS (0): []`, `WEB PAGE ERRORS (0): []`.
- **Verifikasi Alur & Tangkapan Layar**:
  - `Register` header tanpa ikon `?`, judul `Create Account` presisi di tengah (`01_register_header.png`).
  - `Home` atas dan pasca-scroll menunjukkan header brand + Notification tetap *pinned* (`02_home_top.png`, `03_home_scrolled_pinned.png`).
  - `Cart` header memiliki tombol Notification dan `Clear` berada di konten samping `Basket Items`; dialog konfirmasi `'Clear Shopping Cart?'` tampil rapi (`04_cart_header_and_clear.png`, `05_cart_clear_dialog.png`).
  - `Checkout` header bersih tanpa ikon gembok (`06_checkout_header.png`).
  - `PaymentConfirmation` -> `Track My Delivery` -> `Live Tracking` -> tombol Back mendarat di tab `Orders` (`07_live_tracking.png`, `08_back_to_orders.png`).
  - `Orders` -> `Track` -> `Mark Gallon Received` -> `Complete & Rate Delivery` -> `Rate Delivery` -> Back mendarat di `Home` (`09_rating_review.png`, `10_back_to_home.png`).
  - Viewport desktop `1280x800` (`11_desktop_home.png`, `12_desktop_cart_cleared.png`) merender 4 kolom tanpa overflow, dan konfirmasi `Clear Cart` memunculkan toast `'Cart Cleared'` serta empty state `'Your Basket is Empty'`.

### B. Perangkat Fisik Android `vivo 1935` (`fb4262f2`)
- **Instalasi & Eksekusi**: APK debug berhasil dipasang (`adb install`), diuji langsung lewat skrip interaktif `qa_ui_ux_polish_android.py` dengan tombol navigasi sistem (`keyevent 4` / hardware Back) serta interaksi sentuh nyata.
- **Hasil Runtime**: Exit code `0`, `=== LOGCAT ERRORS ===` (`flutter:E`, `AndroidRuntime:E`) kosong (**0 error**).
- **Verifikasi Alur & Tangkapan Layar**:
  - Header `Create Account` bersih tanpa ikon `?` (`and_01_register_header.png`).
  - Header `Home` tetap *pinned* (`notif_before[1] == notif_after[1]`) saat di-swipe (`and_02_home_top.png`, `and_03_home_scrolled_pinned.png`).
  - Toggle Favorite di `ProductDetailScreen` tersinkron mulus saat kembali ke `Home` (`and_04_product_detail.png`, `and_05_product_detail_fav.png`).
  - Tab `Cart` menampilkan Notification di header, `Clear` di konten, dialog `'Clear Shopping Cart?'`, dan `Cancel` mempertahankan isi basket (`and_06_cart.png`, `and_07_cart_clear_dialog.png`).
  - `Checkout` tanpa ikon gembok (`and_08_checkout.png`), berlanjut ke `PaymentConfirmation` -> `Live Tracking`, lalu hardware Back (`keyevent 4`) langsung mendarat di tab `Orders` (`and_10_live_tracking.png`, `and_11_back_to_orders.png`).
  - Dari `Orders` -> `Track` -> `Mark Gallon Received` -> `Complete & Rate Delivery` -> `Rate Delivery` -> hardware Back (`keyevent 4`) mendarat di `Home` dengan state favorit tetap tersinkron (`and_12_rating_review.png`, `and_13_back_to_home.png`).
  - Penambahan item ulang ke Cart -> `Clear` -> konfirmasi `Clear Cart` membersihkan keranjang, menampilkan toast `'Cart Cleared'`, dan merender `'Your Basket is Empty'` (`and_14_cart_before_clear.png`, `and_15_cart_cleared_empty.png`).

---

## 15. Catatan Risiko / Trade-off

1. **`PushAndRemoveUntil` Reset Stack pada Back Tracking / Rating**: Mengarahkan tombol Back di `LiveDeliveryTrackingScreen` ke tab `Orders` dan di `RatingReviewScreen` ke `Home` dengan `pushAndRemoveUntil(..., (route) => false)` menjaga kebersihan root navigation shell (`MainNavigationScreen`) agar pengguna tidak kembali ke layar konfirmasi pembayaran yang sudah berlalu. Konsekuensinya, state gulir (*scroll offset*) sebelumnya pada tab tujuan akan dimulai dari posisi awal saat `MainNavigationScreen` di-rebuild.
2. **Kompatibilitas Pemanggil Lama `rightIcon: SizedBox(width: 42)`**: Beberapa sub-layar lama masih meneruskan `rightIcon: SizedBox(width: 42)`. Penanganan `if (!showNotification || rightIcon is SizedBox) trailingWidget = null` di `FlowinHeader` mengatasi hal ini tanpa harus mengubah semua sub-layar yang tidak termasuk lingkup temuan, namun ke depannya pemanggil baru sebaiknya cukup memakai `showNotification: false`.
3. **Skrip & Screenshot QA Sementara**: Skrip QA dan screenshot verifikasi disimpan di folder scratch conversation dan tidak dicampurkan ke repository kerja aplikasi.

---

## 16. Rekomendasi Lanjutan

1. Pada iterasi berikutnya bila seluruh sub-layar lain dirapikan, parameter `rightIcon: SizedBox(width: 42)` di layar sekunder (`CancelOrderScreen`, `PaymentMethodsScreen`, `PersonalInformationScreen`, `SubscriptionScreen`, `SubscriptionPaymentScreen`) dapat diseragamkan menjadi `showNotification: false`, serta parameter `leftIcon` / `rightIcon` bertipe `SizedBox` bisa disusutkan bertahap.
2. Evaluasi apakah `SubscriptionCheckoutScreen` (yang pada rilis ini sengaja tidak diubah sesuai aturan) juga perlu diseragamkan header-nya atau diberi aksi nyata pada ikon bantuannya jika diperlukan di rilis mendatang.
