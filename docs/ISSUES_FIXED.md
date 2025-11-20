# 🔧 Issues Fixed - Summary

## 1. Nextcloud Database Error ✓

**Issue:** Database "nextcloud" does not exist

**Fixed:**
- Created PostgreSQL database
- Created user and granted permissions
- Restarted Nextcloud

**Access:** http://localhost:8097  
**Credentials:** Create new admin account on first access

---

## 2. PhotoPrism Not Loading ✓

**Issue:** Localhost didn't send any data

**Fixed:**
- Restarted PhotoPrism
- Allowing 60 seconds for startup (it's a large app)

**Access:** http://localhost:2342  
**Default:** admin / admin (change after first login!)

---

## 3. Code Server Password ℹ️

**Current Password:** `changeme`

**To change:**

Edit compose file:
```bash
nano ~/HomeLab/Docker/Compose/ai.yml
# Find PASSWORD line, change value
docker compose -f ~/HomeLab/Docker/Compose/ai.yml up -d
```

**Access:** http://localhost:8443

---

## 4. File Browser Credentials ✓

**Issue:** admin/admin not working

**Fixed:**
- Reset File Browser database
- Recreated with default credentials

**Access:** http://localhost:8087  
**Credentials:** admin / admin  
**⚠️ CHANGE PASSWORD after first login!**

---

## 5. Nginx Proxy Manager ✓

**Issue:** Connection refused

**Fixed:**
- Restarted container (or installed if missing)

**Access:** http://localhost:81  
**Default:** admin@example.com / changeme  
**Note:** You'll be forced to change password on first login

---

## 6. AdGuard Family Filter ✓

**Issue:** Old URL gives 404 error

**Fixed:**
- Provided working replacement filters
- See: ~/HomeLab/docs/ADGUARD_WORKING_FILTERS.txt

**Essential filters to add:**
1. OISD Big List: `https://big.oisd.nl/`
2. Steven Black Hosts: `https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts`
3. 1Hosts Pro: `https://o0.pages.dev/Pro/adblock.txt`

**Add in AdGuard:**
- Filters → DNS blocklists → Add blocklist
- Paste URL and save

---

## ✅ Quick Verification

Run these to verify fixes:

```bash
# Check Nextcloud
curl -I http://localhost:8097

# Check PhotoPrism
curl -I http://localhost:2342

# Check File Browser
curl -I http://localhost:8087

# Check Nginx Proxy Manager
curl -I http://localhost:81

# Check Code Server
curl -I http://localhost:8443
```

All should return 200 or 302/401 (not connection refused)

---

## 🔐 Passwords to Change

**IMMEDIATELY change these default passwords:**

1. **File Browser:** http://localhost:8087
   - Login: admin / admin
   - Click user icon → Settings → Change password

2. **Code Server:** http://localhost:8443
   - Edit compose file to change password
   - Current: `changeme`

3. **Nginx Proxy Manager:** http://localhost:81
   - Login: admin@example.com / changeme
   - You'll be forced to change on first login

4. **PhotoPrism:** http://localhost:2342
   - Login: admin / admin
   - Settings → Account → Change password

**SAVE ALL NEW PASSWORDS TO VAULTWARDEN!**

---

## 📝 Next Steps

1. ✅ Test all services (URLs above)
2. ✅ Change all default passwords
3. ✅ Save passwords to Vaultwarden
4. ✅ Add AdGuard family filters
5. ✅ Create Nextcloud admin account
6. ✅ Configure Nextcloud apps

**All services should now work! 🎉**

