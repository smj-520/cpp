/// Set this to your deployed custom auth handler URL, e.g.
/// https://your-domain.com/auth/index.html
///
/// Keep it empty to use Firebase default hosted pages.
const String kCustomAuthHandlerUrl = 'https://b-teck.web.app/auth/index.html';

bool get hasCustomAuthHandlerUrl => kCustomAuthHandlerUrl.trim().isNotEmpty;
