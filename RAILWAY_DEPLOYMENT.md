# 🚂 Railway.app'te Evolution API Deployment Rehberi

Bu rehber, Evolution API'yi Railway.app üzerinde deploy etmek için adım adım talimatlar içerir.

## 📋 Gereksinimler

- GitHub hesabı
- Railway.app hesabı (GitHub ile bağlanabilirsiniz)
- Bu repository

---

## 🚀 ADIM 1: Railway.app'e Kaydolun

1. [Railway.app](https://railway.app) adresine gidin
2. **"Start a New Project"** veya **"Login"** butonuna tıklayın
3. **"Login with GitHub"** seçeneğini kullanın
4. GitHub hesabınızla Railway'e erişim izni verin

✅ **Tamamlandı!** Artık Railway dashboard'unuzdasınız.

---

## 🐙 ADIM 2: GitHub Repository'yi Hazırlayın

### Mevcut durumda zaten doğru repository'desiniz!

1. Bu dosyaları GitHub'a push edin:
```bash
git add .
git commit -m "Railway deployment configuration added"
git push origin main
```

✅ **Tamamlandı!** Repository hazır.

---

## 🎯 ADIM 3: Railway'de Yeni Proje Oluşturun

1. Railway Dashboard'da **"New Project"** butonuna tıklayın
2. **"Deploy from GitHub repo"** seçeneğini seçin
3. Repository listesinden **`EvolutionAPI-evolution-api`** seçin
4. Railway otomatik olarak repository'yi algılayacak ve deploy etmeye başlayacak

✅ **Tamamlandı!** Proje oluşturuldu.

---

## ⚙️ ADIM 4: Ortam Değişkenleri (Environment Variables) Ekleyin

Railway Dashboard'da projenize tıklayın, sonra:

1. **"Variables"** sekmesine gidin
2. **"RAW Editor"** butonuna tıklayın (daha kolay)
3. Aşağıdaki değişkenleri yapıştırın:

```bash
# API Configuration
AUTHENTICATION_API_KEY=B6D711FCDE4D4FD5936544120E713976
SERVER_TYPE=http
SERVER_PORT=8080

# Database Configuration (Railway PostgreSQL)
DATABASE_ENABLED=true
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=${{Postgres.DATABASE_URL}}
DATABASE_CONNECTION_CLIENT_NAME=evolution_exchange

# Redis Configuration (Optional)
REDIS_ENABLED=false

# RabbitMQ Configuration (Optional)
RABBITMQ_ENABLED=false

# Webhook Configuration
WEBHOOK_GLOBAL_ENABLED=false
WEBHOOK_GLOBAL_URL=

# WhatsApp Configuration
CONFIG_SESSION_PHONE_CLIENT=Evolution API
CONFIG_SESSION_PHONE_NAME=Chrome

# QR Code Configuration
QRCODE_LIMIT=30
QRCODE_COLOR=#198754

# Log Configuration
LOG_LEVEL=ERROR
LOG_COLOR=true
LOG_BAILEYS=error

# Instance Configuration
DEL_INSTANCE=false
DEL_TEMP_INSTANCES=true

# Language
LANGUAGE=en
```

4. **"Add"** veya **"Save"** butonuna tıklayın

### 🗄️ PostgreSQL Veritabanı Ekleme (Önerilen)

1. Proje sayfasında **"New"** butonuna tıklayın
2. **"Database"** → **"Add PostgreSQL"** seçin
3. Railway otomatik olarak `DATABASE_URL` değişkenini oluşturacak
4. Yukarıdaki environment variables'da `${{Postgres.DATABASE_URL}}` referansı bunu kullanır

✅ **Tamamlandı!** Tüm ayarlar yapıldı.

---

## 🔄 ADIM 5: Deploy İşlemini Bekleyin

1. Railway otomatik olarak deploy işlemini başlatacak
2. **"Deployments"** sekmesinden ilerlemeyi izleyin
3. Logları görmek için deployment'a tıklayın
4. Deploy başarılı olduğunda ✅ yeşil onay işareti göreceksiniz

⏱️ **Bekleme süresi:** Yaklaşık 5-10 dakika

✅ **Tamamlandı!** API başarıyla deploy edildi.

---

## 🌐 ADIM 6: Public URL'nizi Alın

1. Proje sayfasında **"Settings"** sekmesine gidin
2. **"Networking"** bölümünü bulun
3. **"Generate Domain"** butonuna tıklayın
4. Railway size şöyle bir URL verecek: `your-project.up.railway.app`

**Alternatif:** Custom domain ekleyebilirsiniz:
1. **"Custom Domains"** bölümüne gidin
2. Kendi domain'inizi ekleyin
3. DNS ayarlarını yapın

✅ **Tamamlandı!** Public URL'niz hazır.

**Örnek URL:** `https://evolutionapi-production.up.railway.app`

---

## 🧪 ADIM 7: API'nizin Çalıştığını Test Edin

### Test 1: Health Check

```bash
curl https://your-project.up.railway.app
```

veya tarayıcınızda adresi açın.

### Test 2: Instance Oluşturma

```bash
curl -X POST https://your-project.up.railway.app/instance/create \
  -H "apikey: B6D711FCDE4D4FD5936544120E713976" \
  -H "Content-Type: application/json" \
  -d '{
    "instanceName": "test-instance",
    "qrcode": true,
    "integration": "WHATSAPP-BAILEYS"
  }'
```

### Test 3: Swagger Dökümantasyonu

Tarayıcınızda şu adresi açın:
```
https://your-project.up.railway.app/docs
```

✅ **Tamamlandı!** API çalışıyor.

---

## 📝 ADIM 8: API Bilgilerinizi Edinin

### 🔑 API Kimlik Bilgileriniz

| Bilgi | Değer |
|-------|-------|
| **Base URL** | `https://your-project.up.railway.app` |
| **API Key** | `B6D711FCDE4D4FD5936544120E713976` |
| **Swagger Docs** | `https://your-project.up.railway.app/docs` |

### 📱 n8n İçin Yapılandırma

**HTTP Request Node Ayarları:**
```
Method: POST
URL: https://your-project.up.railway.app/message/sendText/INSTANCE_NAME
Authentication: None

Headers:
  apikey: B6D711FCDE4D4FD5936544120E713976
  Content-Type: application/json

Body:
{
  "number": "905xxxxxxxxx",
  "text": "Test mesajı"
}
```

---

## 🔐 Güvenlik Önerileri

### ⚠️ ÖNEMLİ: API Key'inizi Değiştirin!

1. Railway Dashboard → Variables sekmesine gidin
2. `AUTHENTICATION_API_KEY` değerini bulun
3. Yeni güçlü bir key oluşturun:

```bash
# Terminalinizde çalıştırın:
openssl rand -hex 32
```

4. Oluşan key'i Railway'de güncelleyin
5. n8n'deki API key'i de güncelleyin

### 🛡️ Diğer Güvenlik Ayarları

1. **Rate Limiting:** Çok sayıda istek gelirse sınırlayıcı ekleyin
2. **IP Whitelist:** Sadece belirli IP'lerden erişim sağlayın
3. **HTTPS:** Railway otomatik HTTPS sağlar ✅
4. **Backup:** Düzenli veritabanı yedekleri alın

---

## 📊 Monitoring & Logs

### Logları İzleme

1. Railway Dashboard → Projeniz
2. **"Deployments"** sekmesi
3. Son deployment'a tıklayın
4. **"View Logs"** ile canlı logları izleyin

### Metrics

Railway otomatik olarak şunları izler:
- CPU kullanımı
- Memory kullanımı
- Network trafiği
- Restart sayısı

---

## 🐛 Sorun Giderme

### Deployment Başarısız Oldu

1. **Logs'u kontrol edin:** Deployment logs'da hata mesajlarını arayın
2. **Environment variables'ı kontrol edin:** Tüm gerekli değişkenleri eklediniz mi?
3. **Build logs'u inceleyin:** Hangi adımda hata oluşuyor?
4. **railway.toml kontrol edin:** `startCommand` içinde `docker-compose up` KULLANMAYIN! Railway, Dockerfile'dan otomatik olarak CMD'yi kullanır.

### API Yanıt Vermiyor

1. **Service çalışıyor mu kontrol edin:** Railway Dashboard → Metrics
2. **Health check yapın:** `curl https://your-url.railway.app`
3. **Port ayarını kontrol edin:** `SERVER_PORT=8080` olmalı

### Database Bağlantı Hatası

1. PostgreSQL service'i eklenmiş mi kontrol edin
2. `DATABASE_CONNECTION_URI` doğru referansı kullanıyor mu: `${{Postgres.DATABASE_URL}}`
3. Database service'i running durumda mı?

### QR Code Alamıyorum

1. Instance doğru oluşturulmuş mu kontrol edin
2. Logs'da Baileys hatalarını arayın
3. `/instance/connect/INSTANCE_NAME` endpoint'ini deneyin

---

## 💰 Maliyet Bilgileri

Railway'nin fiyatlandırması:

- **Hobby Plan:** $5/ay kreди (başlangıç için yeterli)
- **Pro Plan:** $20/ay
- **Kullandıkça öde:** CPU, RAM, Network kullanımına göre

**Not:** Küçük projeler için Hobby plan yeterlidir.

---

## 🔄 Güncelleme

Kod değişikliklerini deploy etmek için:

```bash
git add .
git commit -m "Update message"
git push origin main
```

Railway otomatik olarak yeni deploy başlatır!

---

## 📞 Destek ve Kaynaklar

- **Railway Docs:** https://docs.railway.app
- **Evolution API Docs:** https://doc.evolution-api.com
- **GitHub Issues:** Repository'nizin Issues sekmesi
- **Railway Discord:** https://discord.gg/railway

---

## ✅ Checklist

Deploy sonrası kontrol listesi:

- [ ] Railway projesi oluşturuldu
- [ ] GitHub repository bağlandı
- [ ] Environment variables eklendi
- [ ] PostgreSQL database eklendi
- [ ] Deployment başarılı oldu
- [ ] Public URL alındı
- [ ] API test edildi
- [ ] API Key değiştirildi
- [ ] n8n entegrasyonu yapıldı
- [ ] Webhook yapılandırıldı (opsiyonel)

---

🎉 **Tebrikler!** Evolution API'niz Railway'de başarıyla çalışıyor!
