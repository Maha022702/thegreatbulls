#!/usr/bin/env python3
"""
Script to get Kite Connect access token.
Run this locally to authenticate and get your access token.
"""
from kiteconnect import KiteConnect

API_KEY = "j3xfcw2nl5v4lx3v"
API_SECRET = "d2jx1v3z138wb51njixjy4vtq55otooj"

kite = KiteConnect(api_key=API_KEY)

# Step 1: Get login URL
login_url = kite.login_url()
print("=" * 80)
print("KITE CONNECT AUTHENTICATION")
print("=" * 80)
print("\nStep 1: Visit this URL in your browser and login:")
print(f"\n{login_url}\n")
print("Step 2: After login, you'll be redirected to a URL like:")
print("https://your-redirect-url.com/?request_token=XXXXXX&action=login&status=success")
print("\nStep 3: Copy the 'request_token' value from the URL")
print("=" * 80)

# Step 2: Get request token from user
request_token = input("\nEnter the request_token: ").strip()

try:
    # Step 3: Generate session
    data = kite.generate_session(request_token, api_secret=API_SECRET)
    access_token = data['access_token']
    
    print("\n" + "=" * 80)
    print("SUCCESS! Your access token is:")
    print("=" * 80)
    print(f"\n{access_token}\n")
    print("=" * 80)
    print("\nThis token is valid until end of trading day (until 3:30 PM IST).")
    print("You'll need to generate a new token daily.")
    print("\nTo update in AWS:")
    print(f"aws secretsmanager update-secret --secret-id kite-access-token --secret-string \"{access_token}\" --region us-east-1")
    print("=" * 80)
    
except Exception as e:
    print(f"\nError: {e}")
    print("Please make sure you entered the correct request_token.")
