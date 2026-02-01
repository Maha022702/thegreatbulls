# 🎯 Admin Panel Deployment - Quick Reference Card

## Your Credentials (Save These!)

```
VERCEL_TOKEN: _________________
VERCEL_ORG_ID: _________________
VERCEL_PROJECT_ID: _________________
```

## 3-Step Setup Checklist

### Step 1: Get Credentials (5 min)
- [ ] Go to https://vercel.com/account/tokens
- [ ] Create new token → Copy
- [ ] Go to Vercel Dashboard → thegreatbulls project
- [ ] Settings → General → Copy Project ID and Org ID

### Step 2: Add GitHub Secrets (5 min)
- [ ] GitHub → Settings → Secrets and variables → Actions
- [ ] Add VERCEL_TOKEN
- [ ] Add VERCEL_ORG_ID
- [ ] Add VERCEL_PROJECT_ID

### Step 3: Configure DNS in GoDaddy (5 min)
- [ ] GoDaddy Domains → thegreatbulls.in → DNS
- [ ] Add CNAME: admin → cname.vercel-dns.com
- [ ] TTL: 3600
- [ ] Save

## Deployment Workflow

```bash
# 1. Make changes
edit lib/admin_panel.dart

# 2. Test locally
flutter run -d chrome
# (Press 'r' to reload)

# 3. Commit & Push
git add .
git commit -m "Updated admin panel"
git push origin main

# ✨ DONE! Deployed in 2-5 minutes
```

## Important URLs

| What | URL |
|------|-----|
| Admin Panel | https://admin.thegreatbulls.in |
| GitHub Actions | https://github.com/youruser/thegreatbulls/actions |
| Vercel Dashboard | https://vercel.com/dashboard |
| Vercel Tokens | https://vercel.com/account/tokens |

## Monitoring

| Item | Where to Check |
|------|-----------------|
| Deployment Status | GitHub Actions tab |
| Build Logs | Click workflow run in GitHub |
| Live Site | admin.thegreatbulls.in |
| Deployment History | Vercel Dashboard |

## Commands

```bash
# Development
flutter run -d chrome

# Build test
flutter build web --release

# Deploy
git push origin main

# Check status
git status
git log --oneline -5
```

## Documentation Files

- **QUICK_START_DEPLOYMENT.md** - Start here! (5 min read)
- **DEPLOYMENT_GUIDE.md** - Full details
- **DEPLOYMENT_CHECKLIST.md** - Verification steps
- **DEPLOYMENT_INDEX.md** - Documentation index

## Admin Panel Features

✅ Course Management  
✅ Frontend Customization  
✅ Curriculum Editor  
✅ Analytics Dashboard  
✅ Student Management  
✅ Revenue Tracking  
✅ Settings & Policies  

## Troubleshooting

| Issue | Solution |
|-------|----------|
| DNS not working | Wait 24-48 hours, check CNAME record |
| Deployment fails | Check GitHub Actions logs, verify secrets |
| Changes not showing | Hard refresh (Ctrl+Shift+R), wait 5 min |
| Build error | `flutter clean && flutter pub get` |

## Success Indicators

✅ DNS resolved to Vercel  
✅ GitHub Actions shows "passed"  
✅ Vercel deployment shows "Ready"  
✅ HTTPS lock icon on admin.thegreatbulls.in  
✅ All admin panel features work  

---

**Ready to deploy?** Read QUICK_START_DEPLOYMENT.md now!
