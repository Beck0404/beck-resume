/**
 * 個人網站（beck-resume）—— 純加安全標頭，不做密碼門（對外公開）。
 *
 * 靜態資產由 [assets] binding 提供（wrangler.toml 的 directory = "public"），
 * 這支 Worker 只是把回應接住、補上安全標頭再送出去。
 */

const SECURITY_HEADERS = {
  // 內嵌 JS/CSS 所以 'unsafe-inline'；外部只放行 Google Fonts；
  // 站上沒有 <form>／<input>、不讀 URL 參數，注入面極小。
  "Content-Security-Policy": [
    "default-src 'self'",
    "script-src 'self' 'unsafe-inline'",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
    "font-src 'self' https://fonts.gstatic.com",
    "img-src 'self' data:",
    "connect-src 'self'",
    "object-src 'none'",
    "base-uri 'none'",
    "form-action 'none'",
    "frame-ancestors 'none'",
    "upgrade-insecure-requests",
  ].join("; "),
  "X-Frame-Options": "DENY",
  "X-Content-Type-Options": "nosniff",
  "Referrer-Policy": "strict-origin-when-cross-origin",
  "Permissions-Policy": "camera=(), microphone=(), geolocation=(), payment=(), usb=()",
  "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
  "Cross-Origin-Resource-Policy": "same-origin",
};

export default {
  async fetch(request, env) {
    const res = await env.ASSETS.fetch(request);
    const out = new Response(res.body, res);
    for (const [k, v] of Object.entries(SECURITY_HEADERS)) out.headers.set(k, v);
    return out;
  },
};
