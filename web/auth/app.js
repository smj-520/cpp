/**
 * Custom Firebase email action handler page.
 *
 * Supports:
 *  - verifyEmail
 *  - resetPassword
 *  - recoverEmail
 *
 * Configure using ./config.json
 */

const titleEl = document.getElementById('title');
const subtitleEl = document.getElementById('subtitle');
const messageEl = document.getElementById('message');
const resetSection = document.getElementById('resetSection');
const saveBtn = document.getElementById('saveBtn');
const brandName = document.getElementById('brandName');

const query = new URLSearchParams(window.location.search);
const mode = query.get('mode');
const oobCode = query.get('oobCode');
const continueUrl = query.get('continueUrl');

let apiKey = '';
let appName = 'Hostel Student Wallet';
let configuredContinueUrl = '';

function setMessage(type, text) {
  messageEl.className = `alert ${type}`;
  messageEl.textContent = text;
}

function mapError(code) {
  switch (code) {
    case 'INVALID_OOB_CODE':
      return 'This link is invalid or already used.';
    case 'EXPIRED_OOB_CODE':
      return 'This link has expired. Please request a new one.';
    case 'USER_DISABLED':
      return 'This account is disabled. Contact support.';
    case 'WEAK_PASSWORD':
      return 'Password does not meet requirements: at least 8 characters with uppercase, lowercase, a number, and a symbol.';
    default:
      return code || 'Unexpected error. Please try again.';
  }
}

async function firebasePost(endpoint, payload) {
  const url = `https://identitytoolkit.googleapis.com/v1/${endpoint}?key=${encodeURIComponent(apiKey)}`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });
  const data = await res.json();
  if (!res.ok) {
    const code = data?.error?.message;
    throw new Error(mapError(code));
  }
  return data;
}

function setStaticNav() {
  // Navigation CTAs intentionally removed from UI.
  void continueUrl;
  void configuredContinueUrl;
}

/** Same rules as Flutter `FormValidators.strongPassword` (register / reset in app). */
const MIN_PASSWORD_LEN = 8;

function validatePassword(pass) {
  if (!pass || pass.length < MIN_PASSWORD_LEN) {
    return `Use at least ${MIN_PASSWORD_LEN} characters.`;
  }
  if (!/[A-Z]/.test(pass)) {
    return 'Include at least one uppercase letter (A–Z).';
  }
  if (!/[a-z]/.test(pass)) {
    return 'Include at least one lowercase letter (a–z).';
  }
  if (!/\d/.test(pass)) {
    return 'Include at least one number (0–9).';
  }
  if (!/[^A-Za-z0-9\s]/.test(pass)) {
    return 'Include at least one symbol (e.g. ! @ # $ % ^ & *).';
  }
  return null;
}

async function handleVerifyEmail() {
  titleEl.textContent = 'Verify your email';
  subtitleEl.textContent = 'Applying verification…';
  await firebasePost('accounts:update', { oobCode });
  subtitleEl.textContent = 'Email verified';
  setMessage('success', 'Your Gmail is verified successfully.');
}

async function handleRecoverEmail() {
  titleEl.textContent = 'Recover email';
  subtitleEl.textContent = 'Restoring your account email…';
  await firebasePost('accounts:update', { oobCode });
  subtitleEl.textContent = 'Email recovered';
  setMessage('success', 'Your previous email has been restored.');
}

async function handleResetPassword() {
  titleEl.textContent = 'Reset password';
  subtitleEl.textContent = 'Create a new secure password';
  setMessage('info', 'Choose a new password for your Hostel Student Wallet account.');
  resetSection.classList.remove('hidden');

  saveBtn.addEventListener('click', async () => {
    const pass = document.getElementById('newPassword').value.trim();
    const confirm = document.getElementById('confirmPassword').value.trim();

    const passErr = validatePassword(pass);
    if (passErr) {
      setMessage('error', passErr);
      return;
    }
    if (pass !== confirm) {
      setMessage('error', 'Passwords do not match.');
      return;
    }

    saveBtn.disabled = true;
    saveBtn.innerHTML = '<span class="spinner"></span>Saving…';
    try {
      // Validate code lazily here so form appears instantly.
      await firebasePost('accounts:resetPassword', { oobCode });
      await firebasePost('accounts:resetPassword', {
        oobCode,
        newPassword: pass,
      });
      setMessage('success', 'Password updated successfully. You can log in now.');
      resetSection.classList.add('hidden');
      saveBtn.innerHTML = 'Save password';
    } catch (e) {
      setMessage('error', e.message);
      saveBtn.disabled = false;
      saveBtn.innerHTML = 'Save password';
    }
  });
}

async function bootstrap() {
  setStaticNav();
  try {
    const cfgRes = await fetch('./config.json', { cache: 'no-store' });
    const cfg = await cfgRes.json();
    apiKey = cfg.apiKey || '';
    appName = cfg.appName || appName;
    configuredContinueUrl = cfg.continueUrl || configuredContinueUrl;
    brandName.textContent = appName;
    setStaticNav();
  } catch (e) {
    setMessage('error', 'Missing config.json. Add Firebase API key first.');
    return;
  }

  if (!apiKey) {
    setMessage('error', 'config.json is missing apiKey.');
    return;
  }
  if (!mode || !oobCode) {
    titleEl.textContent = 'Invalid action link';
    subtitleEl.textContent = 'Missing required parameters';
    setMessage('error', 'This link is incomplete. Open the latest email and retry.');
    return;
  }

  try {
    if (mode === 'verifyEmail') {
      await handleVerifyEmail();
      return;
    }
    if (mode === 'resetPassword') {
      await handleResetPassword();
      return;
    }
    if (mode === 'recoverEmail') {
      await handleRecoverEmail();
      return;
    }
    titleEl.textContent = 'Unsupported action';
    subtitleEl.textContent = mode;
    setMessage('error', `Unsupported mode: ${mode}`);
  } catch (e) {
    setMessage('error', e.message || 'Action failed.');
  }
}

bootstrap();
