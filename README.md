# Beck 個人網站（beck-resume）— 部署 repo

范鈞豪 / Chun-Hao Fan 的個人履歷網站（單頁 HTML，中英雙語切換）。
push 到 `main` 後 **同時** 部署到 GitHub Pages 與 Cloudflare Workers，兩個網址內容一致。

| 託管 | 網址 | 觸發 |
|---|---|---|
| GitHub Pages | https://beck0404.github.io/beck-resume/ | `.github/workflows/pages.yml`（push main 自動跑） |
| Cloudflare Workers | https://beck-resume.beck810404.workers.dev | Cloudflare Workers Builds 監看 repo，push main 自動 `npx wrangler deploy` |

- **公開、無密碼門**（是履歷，本來就要給人看）。
- repo 設 **public**（GitHub Pages 免費方案只支援 public repo）。

## 資料流

```
OneDrive\桌面\私人用\beck-resume.html      ← 唯一的原始檔，內容都在這裡改
  → deploy.ps1（複製成 public\index.html + git push）
  → GitHub (public)
      ├→ GitHub Actions → GitHub Pages
      └→ Cloudflare Workers Builds → Workers 靜態資產
```

> ⚠️ `public/index.html` 是 **deploy.ps1 複製出來的副本，直接改會被下次部署覆蓋**。
> 要改內容請改 OneDrive `桌面\私人用\beck-resume.html`。

## 更新網站

1. 改好 `桌面\私人用\beck-resume.html`
2. 執行本 repo 的 `deploy.ps1`（右鍵→用 PowerShell 執行），或跟 Claude 說「**部署個人網站**」
3. 1–2 分鐘後兩個網址都會更新；GitHub Actions 進度看 repo 的 Actions 分頁

## 檔案說明

| 檔案 | 用途 |
|---|---|
| `public/index.html` | 網站本體（副本，見上面警告） |
| `deploy.ps1` | 複製原始檔 + push（**要 UTF-8 BOM**，PowerShell 5.1 才會正確讀中文） |
| `.github/workflows/pages.yml` | GitHub Pages 部署（把 `public/` 原封不動上傳） |
| `wrangler.toml` | Cloudflare Workers 設定，`[assets] directory="public"` |
| `_worker.js` | Cloudflare 端補安全標頭（CSP、X-Frame-Options…），不做密碼門 |

要公開的東西**全部放 `public/`**；根目錄的 README / deploy.ps1 / wrangler.toml 不會被服務出去。
GitHub Pages 那邊沒有 Worker，所以**沒有這組安全標頭**（GitHub 自己會給基本標頭）。

## 首次連接 Cloudflare（一次性，在 Cloudflare 網頁做）

wrangler 本機沒登入，所以走 dashboard 綁 repo：

1. https://dash.cloudflare.com → Workers & Pages → Create → Workers → **Import a repository**
2. 選 GitHub repo `Beck0404/beck-resume`
3. Deploy command 填 `npx wrangler deploy`（build command 留空）
4. Worker 名稱用 `beck-resume`（對應 `wrangler.toml` 的 `name`）→ 網址即 `beck-resume.beck810404.workers.dev`

之後每次 push main 就會自動部署，不用再碰 dashboard。

## 之後想接自己的網域

- **Cloudflare 那邊**：Worker → Settings → Domains & Routes → Add custom domain（網域要先在 Cloudflare 管 DNS）
- **GitHub Pages 那邊**：repo Settings → Pages → Custom domain，並在 `public/` 放 `CNAME` 檔（deploy.ps1 不會動它）
- 二選一即可，兩邊都接同一個網域會打架。

## 備註

- 本 repo 的 git 作者信箱設為個人信箱 `beck810404@gmail.com`（`git config user.email`，repo-local），不是公司信箱。
- 網站內只用 `#錨點` 與絕對外部連結，所以放在 GitHub Pages 的子路徑 `/beck-resume/` 也不會壞。
