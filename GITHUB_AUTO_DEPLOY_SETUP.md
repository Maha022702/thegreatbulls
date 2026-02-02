# GitHub Auto-Deployment Setup Guide

This guide explains how to set up automatic GitHub commits when admin edits education content.

## 🔧 What's Been Done

1. ✅ Created serverless API endpoint: `/api/github/commit-education-content`
2. ✅ Connected admin panel to call this API
3. ✅ API automatically generates Dart code from JSON content
4. ✅ API commits changes to GitHub main branch
5. ✅ GitHub Actions auto-deploys to Vercel

## 📋 Required Setup Steps

### Step 1: Create GitHub Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Set token name: `TheBulls-Admin-Auto-Deploy`
4. Check these scopes:
   - ✅ `repo` (full control of private repositories)
   - ✅ `workflow` (update GitHub Action workflows)
5. Set expiration: 90 days (or No expiration)
6. Click "Generate token"
7. **COPY THE TOKEN** (you won't see it again!)

### Step 2: Add Token to Vercel Environment Variables

1. Go to: https://vercel.com/dashboard
2. Select your project: `thegreatbulls`
3. Go to: **Settings** → **Environment Variables**
4. Add new variable:
   - **Name**: `GITHUB_TOKEN`
   - **Value**: Paste your token from Step 1
   - **Environments**: Select "Production"
5. Click "Save"

### Step 3: Create Admin Authentication Token

1. Create a strong random token. You can use:
   ```bash
   # Run this in terminal to generate a random token
   openssl rand -hex 32
   ```
   Or use: https://www.uuidgenerator.net/

2. Add to Vercel Environment Variables:
   - **Name**: `ADMIN_TOKEN`
   - **Value**: Your generated token
   - **Environments**: Select "Production"
   - Click "Save"

3. **Store this token securely** - you'll need it for admin panel authentication

### Step 4: Update Admin Panel Configuration

When admin panel loads, it needs to use the ADMIN_TOKEN for GitHub commits.

In the admin panel localStorage, the token should be stored as:
```javascript
localStorage['admin_token'] = 'your-admin-token-here'
```

Or you can hardcode it in the admin panel (not recommended for security):
```dart
final adminToken = html.window.localStorage['admin_token'] ?? 'your-token-here';
```

### Step 5: Deploy to Vercel

Push the updated code to trigger deployment:
```bash
git push origin main
```

GitHub Actions will:
1. Build the Flutter app
2. Deploy to Vercel
3. Both `thegreatbulls.in` and `admin.thegreatbulls.in` will be updated

---

## ✅ How It Works

### When Admin Saves Content:

```
1. Admin clicks "Save & Deploy" in Content Editor
   ↓
2. Content saved to browser localStorage (instant)
   ↓
3. Features page updates (real-time)
   ↓
4. Admin panel calls /api/github/commit-education-content
   ↓
5. API validates admin token
   ↓
6. API generates Dart code from JSON
   ↓
7. API commits to GitHub using GITHUB_TOKEN
   ↓
8. GitHub Actions workflow triggers
   ↓
9. Flutter builds web release
   ↓
10. Vercel deploys automatically
    ↓
11. Both domains updated with new content
    ↓
12. Users see fresh content live ✨
```

---

## 🧪 Testing the Setup

### Local Testing (Before Deployment)

1. Run app locally: `flutter run -d chrome`
2. Go to admin.thegreatbulls.in (locally or via tunnel)
3. Login with credentials
4. Edit some content
5. Click "Save & Deploy"
6. Check browser console for any errors
7. Verify Features page updates

### Live Testing (After Deployment)

1. Visit https://admin.thegreatbulls.in
2. Login
3. Edit content (change a title)
4. Click "Save & Deploy"
5. Watch for success message
6. Visit https://thegreatbulls.in/features
7. Verify changes appeared

### Verify GitHub Commit

1. Go to: https://github.com/Maha022702/thegreatbulls
2. Check "Commits" tab
3. You should see commits like: "📚 Update education content from admin panel"
4. Click commit to see what changed
5. Verify Dart code was properly generated

---

## 🔐 Security Notes

1. **GITHUB_TOKEN**: Full repo access - keep it secret!
   - Only stored in Vercel secrets
   - Never commit to code
   - Rotate every 90 days

2. **ADMIN_TOKEN**: Admin authentication
   - Used to verify requests are from authorized admin
   - Should be complex random string
   - Can be rotated independently

3. **Environment Variables**:
   - Never commit `.env` files
   - Use Vercel UI for configuration
   - Different tokens for dev/staging/production

---

## 🐛 Troubleshooting

### "Could not commit to GitHub" Error

**Possible Causes:**
1. GITHUB_TOKEN not set or expired
2. ADMIN_TOKEN mismatch
3. Repository permissions issue
4. Rate limiting

**Solutions:**
1. Verify tokens in Vercel Environment Variables
2. Check GitHub token permissions
3. Check commit message for details in browser console
4. Wait a few minutes if rate limited

### Content Not Updating on Live Site

**Possible Causes:**
1. Vercel deployment still in progress
2. GitHub Actions workflow failed
3. Cache not cleared

**Solutions:**
1. Check Vercel deployment status
2. Check GitHub Actions workflow run
3. Hard refresh: Ctrl+Shift+R (or Cmd+Shift+R on Mac)
4. Clear browser cache completely

### Admin Token Issues

**Verify Token:**
1. Check localStorage in DevTools: `localStorage['admin_token']`
2. Should match ADMIN_TOKEN in Vercel
3. Re-login if needed

---

## 📊 API Endpoint Details

### POST /api/github/commit-education-content

**Headers:**
```json
{
  "Content-Type": "application/json",
  "X-Admin-Token": "your-admin-token"
}
```

**Request Body:**
```json
{
  "content": "{...json education content...}",
  "message": "Optional commit message"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Content committed to GitHub successfully",
  "commitSha": "abc123def456...",
  "commitUrl": "https://github.com/Maha022702/thegreatbulls/commit/abc123..."
}
```

**Error Response (401/400/500):**
```json
{
  "error": "Description of what went wrong"
}
```

---

## 🚀 Next Steps

1. ✅ Create GitHub token (Step 1)
2. ✅ Add tokens to Vercel (Step 2 & 3)
3. ✅ Deploy to live (Step 5)
4. ✅ Test the flow (Testing section)

---

## 📞 Support

If you encounter issues:

1. Check browser console (F12) for errors
2. Check Vercel deployment logs
3. Check GitHub Actions workflow status
4. Verify environment variables are set correctly
5. Review this guide step-by-step

**Last Updated**: February 2, 2026
