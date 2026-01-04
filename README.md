# EvolutionAPI - WhatsApp API Integration

Evolution API, WhatsApp ile entegrasyon için güçlü ve açık kaynaklı bir API çözümüdür.

## � Railway.app'te Deploy

**Railway.app üzerinde deploy etmek için:** [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md) rehberine bakın.

Railway'de deploy sonrası:
- 🔑 API Key: `B6D711FCDE4D4FD5936544120E713976` (mutlaka değiştirin!)
- 🌐 Base URL: `https://your-project.up.railway.app`
- 📚 Swagger Docs: `https://your-project.up.railway.app/docs`

## 🚀 Yerel Kurulum (Docker)

### 1. API Key Bilgisi

**API Key'iniz:** `B6D711FCDE4D4FD5936544120E713976`

⚠️ **Önemli:** Üretim ortamında bu API key'i mutlaka değiştirin!

### 2. Docker ile Yerel Kurulum

```bash
# Docker Compose ile başlatma
docker-compose up -d

# Logları kontrol etme
docker-compose logs -f evolution-api
```

### 3. API Kullanımı

**Base URL:** `http://localhost:8080`

#### Authentication
Tüm API isteklerinde aşağıdaki header'ı kullanın:
```
apikey: B6D711FCDE4D4FD5936544120E713976
```

### 4. n8n Entegrasyonu

n8n'de HTTP Request node kullanarak Evolution API'ye bağlanabilirsiniz:

#### Yeni Instance Oluşturma
```
Method: POST
URL: http://localhost:8080/instance/create
Headers:
  apikey: B6D711FCDE4D4FD5936544120E713976
  Content-Type: application/json

Body:
{
  "instanceName": "my-whatsapp-instance",
  "qrcode": true,
  "integration": "WHATSAPP-BAILEYS"
}
```

#### QR Code Alma
```
Method: GET
URL: http://localhost:8080/instance/connect/:instanceName
Headers:
  apikey: B6D711FCDE4D4FD5936544120E713976
```

#### Mesaj Gönderme
```
Method: POST
URL: http://localhost:8080/message/sendText/:instanceName
Headers:
  apikey: B6D711FCDE4D4FD5936544120E713976
  Content-Type: application/json

Body:
{
  "number": "5511999999999",
  "text": "Merhaba! Bu bir test mesajıdır."
}
```

## 📚 API Endpoints

### Instance Yönetimi
- `POST /instance/create` - Yeni instance oluştur
- `GET /instance/fetchInstances` - Tüm instance'ları listele
- `GET /instance/connect/:instanceName` - Instance'a bağlan (QR Code al)
- `DELETE /instance/logout/:instanceName` - Instance'dan çıkış yap
- `DELETE /instance/delete/:instanceName` - Instance'ı sil

### Mesaj İşlemleri
- `POST /message/sendText/:instanceName` - Text mesaj gönder
- `POST /message/sendMedia/:instanceName` - Medya gönder
- `POST /message/sendLocation/:instanceName` - Konum gönder
- `POST /message/sendContact/:instanceName` - Kişi gönder

### Grup İşlemleri
- `POST /group/create/:instanceName` - Grup oluştur
- `GET /group/fetchAllGroups/:instanceName` - Tüm grupları listele
- `POST /group/updateGroupPicture/:instanceName` - Grup resmi güncelle
- `POST /group/updateGroupSubject/:instanceName` - Grup adı güncelle

## 🔧 Yapılandırma

### Yeni API Key Oluşturma

Güvenlik için kendi API key'inizi oluşturmalısınız:

```bash
# Rastgele güçlü bir key oluşturma
openssl rand -hex 16
```

Oluşturduğunuz key'i `.env` dosyasında `AUTHENTICATION_API_KEY` değişkenine atayın.

### Database Yapılandırması

PostgreSQL kullanılarak tüm instance'lar ve mesajlar saklanır. `.env` dosyasından database ayarlarını değiştirebilirsiniz.

### Webhook Yapılandırması

n8n'de webhook alacak bir endpoint oluşturun ve `.env` dosyasında:

```env
WEBHOOK_GLOBAL_URL=https://your-n8n-instance.com/webhook/evolution
WEBHOOK_GLOBAL_ENABLED=true
WEBHOOK_GLOBAL_WEBHOOK_BY_EVENTS=true
```

## 📖 Dökümantasyon

API dökümantasyonuna şuradan erişebilirsiniz:
- Swagger UI: `http://localhost:8080/docs`
- API Collection: [Evolution API Documentation](https://doc.evolution-api.com)

## 🐛 Sorun Giderme

### Container başlamıyor
```bash
docker-compose down -v
docker-compose up -d
```

### Logları kontrol etme
```bash
docker-compose logs -f evolution-api
```

### Database bağlantı sorunu
`.env` dosyasında `DATABASE_CONNECTION_URI` değerini kontrol edin.

## 🔐 Güvenlik Notları

1. ✅ API Key'inizi mutlaka değiştirin
2. ✅ Firewall kurallarınızı yapılandırın
3. ✅ HTTPS kullanın (production için)
4. ✅ Rate limiting ekleyin
5. ✅ Düzenli backup alın

## 📞 Destek

- [Evolution API GitHub](https://github.com/EvolutionAPI/evolution-api)
- [Evolution API Dökümantasyon](https://doc.evolution-api.com)

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.