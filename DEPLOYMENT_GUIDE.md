# Admin Panel Deployment Guide
## admin.thegreatbulls.in on Vercel

### 📋 Setup Instructions

#### Step 1: Create GitHub Secrets for Vercel Deployment
Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

```
VERCEL_TOKEN: <your-vercel-auth-token>
VERCEL_ORG_ID: <your-vercel-org-id>
VERCEL_PROJECT_ID: <your-vercel-project-id>
```

**How to get these:**
1. Go to https://vercel.com/account/tokens
2. Create a new token → Copy it
3. Go to your Vercel project settings → Copy Project ID and Team ID

#### Step 2: Configure Vercel Domains
1. Go to Vercel Dashboard → Your Project → Settings → Domains
2. Add domain: `admin.thegreatbulls.in`
3. Vercel will provide you nameserver/CNAME info

#### Step 3: Update GoDaddy Nameservers (Already Done)
You've already set nameservers to Vercel - perfect! 

Now add a subdomain routing:
1. In your Vercel project, add the subdomain under "Domains"
2. Or add it via vercel.json (see below)

#### Step 4: DNS Configuration in GoDaddy

Option A: CNAME Record (Recommended)
```
Type: CNAME
Name: admin
Value: cname.vercel-dns.com
TTL: 3600
```

Option B: A Record (if CNAME doesn't work)
```
Type: A
Name: admin
Value: 76.76.19.132 (or latest Vercel IP)
TTL: 3600
```

---

### 🚀 Automatic Deployment Setup

#### Enable GitHub Actions in Your Repo
1. Go to GitHub → Your Repository → Actions
2. Click "New workflow" 
3. The workflow file is already created: `.github/workflows/deploy.yml`
4. It will auto-trigger on:
   - `push` to `main` or `master` branch
   - `pull_request` to test deployments

#### How It Works
```
Code Changes → Push to GitHub → GitHub Actions Triggers →
Flutter Build → Vercel Deploy → admin.thegreatbulls.in Updated ✅
```

---

### 💻 Live Editing & Hot Reload

#### For Development (Local Testing)
```bash
# Terminal 1: Development hot reload
cd /home/aj/Documents/Projects/thegreatbulls
flutter run -d chrome

# Make changes to admin_panel.dart
# Press 'r' in terminal to hot reload
```

#### For Production (Live Changes)
1. Make changes locally
2. Run: `flutter build web --release`
3. Commit: `git add . && git commit -m "Updated admin panel: <description>"`
4. Push: `git push origin main`
5. GitHub Actions automatically:
   - Builds your Flutter app
   - Deploys to Vercel
   - Updates admin.thegreatbulls.in within 2-5 minutes

---

### 📊 Monitoring Deployments

#### Vercel Dashboard
- URL: https://vercel.com
- View real-time deployment status
- Rollback any version if needed

#### GitHub Actions
- Go to: GitHub Repository → Actions
- See build logs and deployment status
- Get notifications on success/failure

#### Check Live Admin Panel
```
https://admin.thegreatbulls.in
```

---

### 🔧 Vercel Configuration (vercel.json)

The configuration includes:
- ✅ Flutter build command
- ✅ Output directory: `build/web`
- ✅ SPA routing (all routes → index.html)
- ✅ Cache control for assets
- ✅ Security headers
- ✅ Long-lived cache for /assets/*

---

### 📝 Recommended Workflow

**Daily Development:**
```bash
# 1. Make changes to admin_panel.dart
# 2. Test locally with hot reload
flutter run -d chrome
# 3. Press 'r' to see changes instantly

# 4. When ready for production
git add .
git commit -m "Feature: Enhanced course management UI"
git push origin main

# 5. Sit back - GitHub Actions handles deployment! ✅
```

**Status Check:**
```bash
# Check GitHub Actions status
git log --oneline # See your commits
# Then go to GitHub → Actions tab to see deployment progress
```

---

### 🔐 Security Best Practices

✅ Environment variables are in GitHub Secrets (never in code)
✅ Vercel handles SSL/HTTPS automatically
✅ Security headers configured in vercel.json
✅ Cache busting for assets (immutable hashes)
✅ Automatic redirects for http → https

---

### 🐛 Troubleshooting

**Issue: Deployment fails in GitHub Actions**
- Check GitHub Actions logs (Actions tab)
- Verify VERCEL_TOKEN is valid
- Ensure secrets are set in repository settings

**Issue: Domain not resolving**
- Wait 24-48 hours for DNS propagation
- Check GoDaddy nameservers are pointing to Vercel
- Verify CNAME record in GoDaddy DNS

**Issue: Changes not showing live**
- Clear browser cache (Ctrl+Shift+Del)
- Check Vercel deployment completed successfully
- Wait 2-5 minutes for CDN to update

**Issue: Build fails locally**
- Run: `flutter clean && flutter pub get`
- Run: `flutter build web --release`
- Check build.sh has execute permissions

---

### 📈 Performance Monitoring

After deployment, monitor at:
1. **Vercel Analytics**: vercel.com/dashboard
2. **Lighthouse**: Use Chrome DevTools → Lighthouse
3. **Real Users**: Check Core Web Vitals in Vercel dashboard

---

### 🎯 Next Steps

1. ✅ Set up GitHub Secrets (VERCEL_TOKEN, etc.)
2. ✅ Configure DNS in GoDaddy (add admin subdomain)
3. ✅ Push code to GitHub
4. ✅ Monitor first deployment in GitHub Actions
5. ✅ Test admin.thegreatbulls.in accessibility
6. ✅ Set up automatic deployments (already configured!)

---

### 📞 Support

For issues:
- Vercel Docs: https://vercel.com/docs
- Flutter Web: https://flutter.dev/web
- GitHub Actions: https://docs.github.com/en/actions
