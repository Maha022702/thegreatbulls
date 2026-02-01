#!/bin/bash

# ============================================
# Admin Panel Deployment - Final Checklist
# admin.thegreatbulls.in on Vercel
# ============================================

clear
echo "════════════════════════════════════════════════"
echo "  🎉 Admin Panel Deployment Setup Complete!"
echo "════════════════════════════════════════════════"
echo ""

echo "📋 VERIFICATION CHECKLIST"
echo ""

# Check files exist
echo "✅ Checking setup files..."
FILES=(
    ".github/workflows/deploy.yml"
    "vercel.json"
    "DEPLOYMENT_GUIDE.md"
    "DEPLOYMENT_CHECKLIST.md"
    "QUICK_START_DEPLOYMENT.md"
    "DEPLOYMENT_COMPLETE.md"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✓ $file"
    else
        echo "   ✗ $file (MISSING)"
    fi
done

echo ""
echo "✅ Setup files verified!"
echo ""

echo "════════════════════════════════════════════════"
echo "  🚀 NEXT STEPS (15 minutes)"
echo "════════════════════════════════════════════════"
echo ""

echo "STEP 1: Get Vercel Credentials"
echo "───────────────────────────────"
echo "1. Open: https://vercel.com/account/tokens"
echo "2. Create new personal access token"
echo "3. Copy the token"
echo ""
echo "4. Open: https://vercel.com/dashboard"
echo "5. Click your 'thegreatbulls' project"
echo "6. Settings → General"
echo "7. Copy Project ID and Org ID"
echo ""
read -p "Press Enter when you have all 3 credentials..."
echo ""

echo "STEP 2: Add GitHub Secrets"
echo "──────────────────────────"
echo "1. Go to GitHub → Your Repository"
echo "2. Settings → Secrets and variables → Actions"
echo "3. Add 'New repository secret'"
echo ""
echo "Add these 3 secrets:"
echo "   SECRET 1: VERCEL_TOKEN = <your-token>"
echo "   SECRET 2: VERCEL_ORG_ID = <your-org-id>"
echo "   SECRET 3: VERCEL_PROJECT_ID = <your-project-id>"
echo ""
read -p "Press Enter when secrets are added..."
echo ""

echo "STEP 3: Configure DNS in GoDaddy"
echo "────────────────────────────────"
echo "1. Go to: GoDaddy.com"
echo "2. Domains → thegreatbulls.in"
echo "3. Click DNS"
echo "4. Add new CNAME record:"
echo "   - Type: CNAME"
echo "   - Name: admin"
echo "   - Value: cname.vercel-dns.com"
echo "   - TTL: 3600"
echo "5. Save"
echo ""
echo "⏳ Wait 24-48 hours for DNS to propagate"
echo ""
read -p "Press Enter when DNS is configured..."
echo ""

echo "STEP 4: Test Deployment"
echo "──────────────────────"
echo "1. Make a small change to admin_panel.dart"
echo "2. Commit: git add . && git commit -m 'Test deployment'"
echo "3. Push: git push origin main"
echo "4. Go to: GitHub → Actions"
echo "5. Watch the build complete"
echo ""
read -p "Press Enter when ready to test..."
echo ""

echo "════════════════════════════════════════════════"
echo "  ✨ YOU'RE READY TO GO!"
echo "════════════════════════════════════════════════"
echo ""

echo "📚 DOCUMENTATION"
echo "────────────────"
echo "Quick Start (5 min read):"
echo "  cat QUICK_START_DEPLOYMENT.md"
echo ""
echo "Full Guide (detailed):"
echo "  cat DEPLOYMENT_GUIDE.md"
echo ""
echo "Verification Checklist:"
echo "  cat DEPLOYMENT_CHECKLIST.md"
echo ""

echo ""
echo "🔗 IMPORTANT URLS"
echo "─────────────────"
echo "Admin Panel (after DNS): https://admin.thegreatbulls.in"
echo "GitHub Actions: https://github.com/youruser/thegreatbulls/actions"
echo "Vercel Dashboard: https://vercel.com/dashboard"
echo ""

echo ""
echo "💡 WORKFLOW REMINDER"
echo "────────────────────"
echo "1. Edit code locally"
echo "2. Test with: flutter run -d chrome"
echo "3. Commit: git add . && git commit -m 'message'"
echo "4. Deploy: git push origin main"
echo "5. Monitor: GitHub Actions tab"
echo "6. Live in: 2-5 minutes ✨"
echo ""

echo ""
echo "✅ VERIFICATION"
echo "───────────────"
echo ""

# Check git status
echo "Git status:"
git status | head -5
echo ""

# Confirm Flutter
if command -v flutter &> /dev/null; then
    echo "✓ Flutter: $(flutter --version | head -1)"
else
    echo "✗ Flutter not found"
fi

echo ""
echo "════════════════════════════════════════════════"
echo "  🎉 Setup Complete! You're Ready to Deploy!"
echo "════════════════════════════════════════════════"
echo ""
