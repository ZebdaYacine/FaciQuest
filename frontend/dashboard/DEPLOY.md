# Deploying the dashboard to Dokploy

The admin dashboard ships as a Docker image: a compiled Flutter web bundle
served by nginx. GitHub Actions builds and pushes it to GHCR, then asks Dokploy
to pull. **The VPS never builds** — a `flutter build web` competing for RAM with
the running containers is the usual way a single-node Dokploy host falls over,
taking every app on it down with it.

```
push to `frontend`  →  GH Actions: build → push GHCR → smoke-test
                    →  POST /api/application.deploy  →  Dokploy pulls & restarts
                    →  poll DASHBOARD_HEALTH_URL
```

Files involved:

| File | Purpose |
| --- | --- |
| `Dockerfile` | Flutter 3.44.2 → static bundle → `nginx:1.27-alpine` |
| `nginx.conf` | SPA fallback, `/healthz`, cache headers |
| `.dockerignore` | keeps stale `*.tar.gz` / `*.zip` build output out of the image |
| `../../.github/workflows/release-dashboard.yml` | the deploy path |

---

## The one thing to understand first

`lib/services/app_config.dart` reads config through `flutter_dotenv`, and
`pubspec.yaml` declares `.env` as an **asset**. The file is compiled *into* the
bundle at build time — the same one-way door as `NEXT_PUBLIC_*` in Next.js.

**Repointing the API is a rebuild, not a restart.** Setting an environment
variable on the Dokploy Application does nothing. `API_BASE_URL` is a Docker
build arg, and the Dockerfile fails the build if it is empty rather than letting
the app silently fall back to the hardcoded `http://185.209.230.104:3000`.

---

## One-time setup

### Step 1 — Make sure the API is reachable over HTTPS

The dashboard will be served over HTTPS. A browser blocks `http://` requests
from an HTTPS page as mixed content *before the request is ever sent*, so a
plain-http `API_BASE_URL` produces a dashboard that loads and then fails every
call with no useful error.

Give the API a hostname with a certificate (its own Dokploy domain works) and
note the URL — e.g. `https://api.faciquest.example`. The workflow emits a
warning, not an error, if you use `http://`; heed it.

### Step 2 — Create the Dokploy Application

In the Dokploy UI:

1. Open (or create) a project → **Create Service** → **Application**.
2. Name it `faciquest-dashboard`.
3. **Provider / Source Type: `Docker`** — not Git. Dokploy must pull a finished
   image, not build one.
4. Docker image:
   ```
   ghcr.io/zebdayacine/faciquest-dashboard:frontend
   ```
   `frontend` is the moving tag that follows the branch. To pin or roll back,
   use a `sha-<short>` tag instead (see [Rolling back](#rolling-back)).
5. If the GHCR package is **private**, add a registry credential — username =
   your GitHub username, password = a PAT with `read:packages`. Making the
   package public under GHCR → Package settings is simpler and this bundle
   contains no secrets.
6. **Domains** tab → add your hostname (e.g. `dash.faciquest.example`),
   **Container Port `80`**, HTTPS on, certificate provider **Let's Encrypt**.
   Point the DNS A record at the VPS first, or the certificate issue fails.
7. **Advanced → Auto Deploy: OFF.** This matters. Dokploy's own git webhook
   fires the moment you push — minutes before the image finishes building — and
   would redeploy the *previous* image. The workflow's `deploy` job is the
   trigger, and it only runs after the new image exists and passed its smoke
   test.
8. **Deploy** once. It will pull whatever is in GHCR; if nothing is there yet,
   that's expected — Step 4 fixes it.
9. Copy the **application id** out of the browser URL. It is the last segment:
   `…/services/application/<applicationId>`.

### Step 3 — Add the GitHub secrets and variables

`Settings → Secrets and variables → Actions`.

**Secrets** (values are hidden):

| Name | Value |
| --- | --- |
| `DOKPLOY_URL` | Dokploy panel base URL, no trailing slash — `https://dokploy.yourhost` |
| `DOKPLOY_API_KEY` | Dokploy → your avatar → **Profile / API Keys** → generate |
| `DOKPLOY_APP_ID_DASHBOARD` | the application id from Step 2.9 |

**Variables** (values are visible in logs — that's fine, and useful):

| Name | Value |
| --- | --- |
| `API_BASE_URL` | the HTTPS API URL from Step 1 |
| `DASHBOARD_HEALTH_URL` | `https://dash.faciquest.example/healthz` |

If `DASHBOARD_HEALTH_URL` is missing the deploy still runs, but the workflow
warns and skips verification — it will report success without knowing whether
the new bundle is actually serving.

### Step 4 — Prove the build before wiring it to a push

Actions → **Release dashboard image** → **Run workflow**. The `api_base_url`
input overrides the repo variable, so you can test a value without committing to
it.

A manual run builds, pushes, and smoke-tests, but **does not deploy** — the
`deploy` job is gated on `github.event_name == 'push'`. That's deliberate: it
lets you confirm the image is good in isolation.

The smoke test starts the pushed image and checks four things:

- `/healthz` answers
- `/` is the Flutter shell (contains `flutter_bootstrap.js`)
- `/assets/.env` contains exactly the `API_BASE_URL` you intended
- `/users` returns 200, i.e. the SPA deep-link fallback works

If it goes green, hit **Deploy** on the Dokploy Application manually and load the
site. You now have a working deployment.

---

## Deploying, from then on

```bash
git push origin frontend
```

The workflow triggers only on changes under `frontend/dashboard/**` or to the
workflow file itself, so unrelated commits on the branch don't rebuild it.

Watch it in Actions. On success the run summary prints the `sha-` tag that
`frontend` now resolves to — keep that if you might need to roll back.

To deploy without a code change (e.g. after changing `API_BASE_URL`), use
**Run workflow** and then press **Deploy** in Dokploy; a `workflow_dispatch` run
builds the new image but does not trigger the pull.

---

## Rolling back

Every build also pushes an immutable `sha-<short>` tag.

1. Find the good tag — the run summary of that deploy, or the GHCR package's
   Versions list.
2. Dokploy → the Application → change the image to
   `ghcr.io/zebdayacine/faciquest-dashboard:sha-abc1234`.
3. **Deploy**.

Set the image back to `:frontend` once the fix is merged, otherwise the next
workflow run pushes an image the Application is no longer watching and "nothing
happens" on deploy.

---

## When it goes wrong

**Build fails: `API_BASE_URL build-arg is empty`**
The `API_BASE_URL` repo *variable* is missing or was added under Secrets by
mistake. It must be a Variable — the workflow reads it via `vars.`.

**Build fails at the final `grep` in the Dockerfile**
The `.env` asset was not baked where expected, usually because `pubspec.yaml`
stopped declaring `.env` under `assets:`. The app would run entirely on defaults;
this check exists so you find out here rather than from a white screen.

**Actions is green but the site serves the old build**
Auto Deploy is probably ON, so Dokploy redeployed on the push webhook and the
later API call was a no-op against an already-current container. Turn it off
(Step 2.7). Otherwise the Application's image tag is pinned to a `sha-` tag from
a rollback — set it back to `:frontend`.

**Site loads, every API call fails, console shows a mixed-content or CORS error**
Mixed content: `API_BASE_URL` is `http://`. Rebuild with the HTTPS URL.
CORS: the API must allow the dashboard's origin — that's an API-side fix, and no
dashboard rebuild will change it.

**Hard refresh on a deep link 404s**
nginx's `try_files … /index.html` fallback isn't in effect — check that
`nginx.conf` was copied into the image.

**A returning user still sees the previous version**
`index.html`, `flutter_service_worker.js` and `assets/.env` are served
`no-store` precisely to prevent this. If it persists, something in front of the
container (Cloudflare, a CDN) is caching them; exclude those three paths there
too.

**Deploy job: `dashboard did not answer at …`**
Dokploy accepted the deploy but the container never came up within 5 minutes.
Read the Application's logs in Dokploy — usually the image pull failed on a
private GHCR package with no registry credential.

**`docker build` fails locally on an Apple Silicon Mac**
The Flutter SDK archive is x64-only. Use
`docker build --platform linux/amd64 .` with qemu enabled. CI builds
`linux/amd64` for the same reason.
