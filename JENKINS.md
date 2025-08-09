# Jenkins CI/CD Pipeline Setup

Bu dosya, Git push işlemlerinde otomatik olarak Docker image build ve publish yapmak için Jenkins pipeline kurulumu hakkında bilgiler içerir.

## 🔧 Jenkins Kurulumu

### 1. Gerekli Pluginler
Jenkins'e aşağıdaki pluginleri yükleyin:
- **Docker Pipeline Plugin**
- **Git Plugin** 
- **GitHub Integration Plugin**
- **Pipeline Plugin**

### 2. Docker Hub Credentials
Jenkins'te Docker Hub kimlik bilgilerinizi ayarlayın:

1. Jenkins Dashboard → Manage Jenkins → Manage Credentials
2. "Add Credentials" → "Username with password"
3. **ID:** `docker-hub-credentials`
4. **Username:** Docker Hub kullanıcı adınız
5. **Password:** Docker Hub şifreniz veya access token

### 3. Jenkins Job Oluşturma

#### Pipeline Job:
1. "New Item" → "Pipeline" → Job adı girin
2. **Pipeline** bölümünde:
   - **Definition:** Pipeline script from SCM
   - **SCM:** Git
   - **Repository URL:** Git repository URL'niz
   - **Script Path:** `Jenkinsfile` (root) veya `src/Presentation/WebApi/Jenkinsfile` (WebApi için)

#### Multibranch Pipeline (Önerilen):
1. "New Item" → "Multibranch Pipeline"
2. **Branch Sources** → Git ekleyin
3. **Repository URL:** Git repository URL'niz
4. **Credentials:** Git credentials (gerekirse)

## 📁 Pipeline Dosyaları

### Root Jenkinsfile
**Konum:** `/Jenkinsfile`
**Özellikler:**
- ✅ Tam CI/CD pipeline
- ✅ Multi-environment deployment (dev/prod)
- ✅ Health check testleri
- ✅ Otomatik cleanup
- ✅ Branch-based deployment

### WebApi Jenkinsfile  
**Konum:** `/src/Presentation/WebApi/Jenkinsfile`
**Özellikler:**
- ✅ Basit build ve push pipeline
- ✅ WebApi projesine odaklı
- ✅ Hızlı deployment

## 🚀 Pipeline Akışı

### Git Push → Jenkins Trigger
```
1. 📤 Git Push (main/develop branch)
2. 🔔 Jenkins webhook trigger
3. 🔨 Docker image build
4. 🧪 Health check tests
5. 📦 Docker Hub'a push
6. 🚀 Otomatik deployment
```

### Branch Strategy
- **main/master:** Production deployment
- **develop:** Development deployment  
- **feature branches:** Sadece build ve test

## ⚙️ Konfigürasyon

### Environment Variables
Jenkinsfile'da düzenlemeniz gerekenler:

```groovy
environment {
    DOCKER_REGISTRY = 'your-dockerhub-username' // ← Buraya kullanıcı adınızı yazın
    DOCKER_IMAGE = 'library-webapi'
}
```

### Webhook Setup (Otomatik Trigger)
GitHub/GitLab'da webhook ayarlayın:

**GitHub:**
1. Repository → Settings → Webhooks
2. **Payload URL:** `http://your-jenkins-url/github-webhook/`
3. **Content type:** application/json
4. **Events:** Push events

**GitLab:**
1. Repository → Settings → Webhooks  
2. **URL:** `http://your-jenkins-url/project/your-job-name`
3. **Trigger:** Push events

## 📋 Manual Trigger

Pipeline'ı manuel olarak çalıştırmak için:

```bash
# Jenkins CLI ile
java -jar jenkins-cli.jar -s http://your-jenkins-url build your-job-name

# Veya Jenkins web arayüzünden "Build Now" butonu
```

## 🧪 Test Etme

Pipeline'ın çalışıp çalışmadığını test etmek için:

1. Kod değişikliği yapın
2. Git'e push edin
3. Jenkins job'ını kontrol edin
4. Docker Hub'da image'ın yüklendiğini doğrulayın

## 🔍 Troubleshooting

### Yaygın Sorunlar:

**Docker permission denied:**
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

**Git credentials hatası:**
- Jenkins'te Git credentials ekleyin
- SSH key kullanıyorsanız Jenkins'e private key ekleyin

**Docker Hub push hatası:**
- Docker Hub credentials'ın doğru olduğunu kontrol edin
- Docker Hub'da repository'nin public olduğunu kontrol edin

## 📊 Pipeline Monitoring

Jenkins Dashboard'da pipeline durumunu takip edebilirsiniz:
- ✅ **Blue Ocean** plugin ile görsel pipeline view
- 📊 **Build history** ve **Console output**
- 📈 **Pipeline stage view** ile detaylı analiz
