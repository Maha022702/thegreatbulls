# Kite Connect Access Token Setup

## Your API Credentials
- **API Key**: `j3xfcw2nl5v4lx3v`
- **API Secret**: `d2jx1v3z138wb51njixjy4vtq55otooj`

## How to Get Your Access Token

### Step 1: Visit the Login URL
Open this URL in your browser:
```
https://kite.zerodha.com/connect/login?api_key=j3xfcw2nl5v4lx3v&v=3
```

### Step 2: Login with Zerodha Credentials
- Enter your Zerodha User ID, Password, and PIN
- Complete any 2FA if enabled

### Step 3: Get the Request Token
After successful login, you'll be redirected to a URL like:
```
https://127.0.0.1/?request_token=XXXXXXXXXXXXXXXXXX&action=login&status=success
```

Copy the `request_token` value (the XXXX part)

### Step 4: Generate Access Token
Run this command with your request token:

```bash
curl -X POST "https://api.kite.trade/session/token" \
  -d "api_key=j3xfcw2nl5v4lx3v" \
  -d "request_token=YOUR_REQUEST_TOKEN_HERE" \
  -d "checksum=$(echo -n 'j3xfcw2nl5v4lx3vYOUR_REQUEST_TOKEN_HEREd2jx1v3z138wb51njixjy4vtq55otooj' | sha256sum | cut -d' ' -f1)"
```

Replace `YOUR_REQUEST_TOKEN_HERE` with the actual request token from step 3.

### Step 5: Update AWS Secret
After getting the access token from the response, update AWS:

```bash
aws secretsmanager update-secret \
  --secret-id kite-access-token \
  --secret-string "YOUR_ACCESS_TOKEN" \
  --region us-east-1
```

### Step 6: Restart ECS Service
```bash
aws ecs update-service \
  --cluster kite-cluster \
  --service kite-collector-service \
  --force-new-deployment \
  --region us-east-1
```

## Important Notes
- Access tokens are valid only until the end of the trading day (3:30 PM IST)
- You'll need to regenerate the access token daily
- Keep your credentials secure and never commit them to version control
