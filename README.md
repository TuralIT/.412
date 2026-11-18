# Nightshift

## Kur / Install (tek satır / one line)

PowerShell'e yapıştır / paste into PowerShell:

```powershell
irm https://raw.githubusercontent.com/TuralIT/.412/main/install.ps1 | iex
```

CMD'ye yapıştır / paste into CMD:

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/TuralIT/.412/main/install.ps1 | iex"
```

**TR:** İndirir, kurar, masaüstüne **Nightshift** kısayolu koyar ve açar. Bundan sonra hep o kısayolla aç: her açılışta yeni sürüm varsa kendisi indirir (sadece değişen dosyalar, birkaç MB). İnternet yoksa direkt açılır. Ayarların ve öğrenilen cevaplar korunur.

**EN:** Downloads, installs, puts a **Nightshift** shortcut on the desktop and starts it. From then on always open it with that shortcut: on every start it fetches a new version by itself if there is one (only the changed files, a few MB). No internet: it just opens. Your settings and learned answers are kept.

## İlk açılış / First start

### TR
1. Windows uyarırsa: **Ek bilgi → Yine de çalıştır**.
2. Kendi tuşlarını gir: Ayarlar → Genel (başlat/durdur), Ayarlar → Meth (bagaj tuşu, kilit tuşu L).
3. Öğrenilmiş meth cevaplarını içe aktarmayı teklif ederse **evet** de.
4. FiveM'de sunucuya gir; oyun yüklenince Nightshift oyunu kendisi bulur.
5. Meth: arka koltukta otur (`/koltuk 4`), aracı **L** ile kilitle, Meth Lab üzerinde olsun, sonra başlat.
   - Meth, sıradaki üretime yer kaldıkça üzerinde kalır. Yer bitince araç deposuna sığdığı kadarı (ağırlığa göre hesaplanır) konur; depo da doluysa bot iner, Shift+E ile bagaja gider, methi bagaja koyar, F + `/koltuk 4` ile geri biner.
   - 5x ASETON / 2x LITYUM'dan azı kalınca araç deposundan 10 üretimlik (50 + 20) alınır, ama sadece üzerine sığdığı kadar. Hiç yoksa: meth araca, araç kilitlenir, oyun kapanır.
   - Her üretimden sonra log'da planını yazar (boş kg, kaç üretimlik malzeme, araçta boş yer).
   - Meth Lab asla araca konmaz.

### EN
1. If Windows warns: **More info → Run anyway**.
2. Set your own keys: Settings → General (start/stop), Settings → Meth (storage key, lock key L).
3. Say **yes** when it offers to import the learned meth answers.
4. Join the server in FiveM; once the game has loaded, Nightshift finds it by itself.
5. Meth: sit in the back seat (`/koltuk 4`), lock the car with **L**, have the Meth Lab on you, then start.
   - The meth stays on you while there's room for the next cook. Then exactly as much as fits (by weight) goes into the car storage; if that's full too, the bot gets out, Shift+E to the trunk, puts the meth there and gets back in with F + `/koltuk 4`.
   - Under 5x ASETON / 2x LITYUM it takes 10 cooks' worth (50 + 20) from the car storage, only as much as fits on you. None anywhere: meth into the car, car locked, game closed.
   - After every cook it writes its plan in the log (kg free, cooks of ingredients, room in the car).
   - The Meth Lab is never put in the car.

Sürümler / Versions: [Releases](https://github.com/TuralIT/.412/releases) · Elle indir / manual download: [Nightshift.zip](https://github.com/TuralIT/.412/releases/latest/download/Nightshift.zip)
