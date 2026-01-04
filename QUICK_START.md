# 🚀 Evolution API - Hızlı Başlangıç Kılavuzu

## 🎯 Ne Yapacağız?

Evolution API'yi Railway.app üzerinde deploy edip n8n ile entegre edeceğiz.

---

## ⚡ 5 Dakikada Railway Deploy

### 1️⃣ Hazırlık (2 dakika)

```bash
# GitHub'a dosyaları push et
git add .
git commit -m "Railway deployment ready"
git push origin main
```

### 2️⃣ Railway'de Deploy (2 dakika)

1. [Railway.app](https://railway.app) → GitHub ile giriş yap
2. **New Project** → **Deploy from GitHub**
3. `EvolutionAPI-evolution-api` repo'sunu seç
4. Bekle... ☕

### 3️⃣ Environment Variables (1 dakika)

Railway Dashboard → **Variables** → **RAW Editor** → Yapıştır:

```env
AUTHENTICATION_API_KEY=B6D711FCDE4D4FD5936544120E713976
SERVER_TYPE=http
SERVER_PORT=8080
DATABASE_ENABLED=true
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=${{Postgres.DATABASE_URL}}
LOG_LEVEL=ERROR
LANGUAGE=en
```

**PostgreSQL Ekle:** New → Database → PostgreSQL

### 4️⃣ Public URL Al (30 saniye)

Settings → Networking → **Generate Domain**

✅ URL'niz: `https://evolutionapi-production.up.railway.app`

---

## 🧪 Test Et

### Basit Test

Tarayıcıda aç:
```
https://your-project.up.railway.app/docs
```

### API ile Test

```bash
# Instance oluştur
curl -X POST https://your-project.up.railway.app/instance/create \
  -H "apikey: B6D711FCDE4D4FD5936544120E713976" \
  -H "Content-Type: application/json" \
  -d '{"instanceName": "test", "qrcode": true, "integration": "WHATSAPP-BAILEYS"}'
```

---

## 📱 n8n'de Kullan

### HTTP Request Node Ayarları:

```
URL: https://your-project.up.railway.app/message/sendText/INSTANCE_NAME
Method: POST
Authentication: None

Headers:
  apikey: B6D711FCDE4D4FD5936544120E713976
  Content-Type: application/json

Body (JSON):
{
  "number": "905xxxxxxxxx",
  "text": "Merhaba n8n!"
}
```

---

## 🔑 Önemli Bilgiler

| Bilgi | Değer |
|-------|-------|
| **Base URL** | `https://your-project.up.railway.app` |
| **API Key** | `B6D711FCDE4D4FD5936544120E713976` |
| **Docs** | `https://your-project.up.railway.app/docs` |

⚠️ **API Key'i üretimde mutlaka değiştir!**

```bash
# Yeni key oluştur:
openssl rand -hex 32
```

---

## 📚 Popüler Endpoint'ler

### 1. Instance Oluştur
```http
POST /instance/create
Header: apikey: YOUR_API_KEY
Body: {"instanceName": "myinstance", "qrcode": true, "integration": "WHATSAPP-BAILEYS"}
```

### 2. QR Code Al
```http
GET /instance/connect/myinstance
Header: apikey: YOUR_API_KEY
```

### 3. Mesaj Gönder
```http
POST /message/sendText/myinstance
Header: apikey: YOUR_API_KEY
Body: {"number": "905xxxxxxxxx", "text": "Merhaba!"}
```

### 4. Instance Listesi
```http
GET /instance/fetchInstances
Header: apikey: YOUR_API_KEY
```

### 5. Grup Oluştur
```http
POST /group/create/myinstance
Header: apikey: YOUR_API_KEY
Body: {"subject": "Grup Adı", "participants": ["905xxxxxxxxx"]}
```

---

## 🐛 Sorun mu Var?

### Deploy başarısız
→ Railway logs'u kontrol et: Deployments → View Logs

### API yanıt vermiyor
→ URL doğru mu? HTTPS kullanıyor musun?

### Database hatası
→ PostgreSQL service ekledin mi?

### QR Code alamıyorum
→ Instance doğru oluşturulmuş mu kontrol et

---

## 📖 Detaylı Rehberler

- 🚂 **Railway Deploy:** [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md)
- 📚 **Tüm API Endpoints:** [README.md](README.md)
- 🌐 **Official Docs:** https://doc.evolution-api.com

---

## ✅ Checklist

- [ ] Railway'e GitHub ile giriş yaptım
- [ ] Repo'yu Railway'e bağladım
- [ ] Environment variables ekledim
- [ ] PostgreSQL database ekledim
- [ ] Public URL aldım
- [ ] API'yi test ettim
- [ ] API Key'i değiştirdim
- [ ] n8n'de test ettim

---

🎉 **Hazırsın!** Artık WhatsApp mesajları gönderebilirsin!

**Soru mu var?** [Issues](https://github.com/Kadba71/EvolutionAPI-evolution-api/issues) açabilirsin.
