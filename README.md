<div align="center">
  <img src="public/favicon.svg" width="68" height="68" alt="Sabit Al Alfi portfolio mark" />

  <h1>Sabit Al Alfi — Portfolio & CMS</h1>

  <p>
    A research-led digital portfolio for explainable AI, academic work, and practical software engineering.
  </p>

  <p>
    <a href="https://sabit-al-alfi-portfolio.vercel.app"><strong>View live portfolio ↗</strong></a>
    &nbsp;·&nbsp;
    <a href="https://sabit-al-alfi-portfolio.vercel.app/admin/login"><strong>CMS sign in</strong></a>
  </p>

  <p>
    <img alt="Astro 7" src="https://img.shields.io/badge/Astro_7-0b0b0d?style=flat-square&logo=astro&logoColor=BC52EE" />
    <img alt="TypeScript" src="https://img.shields.io/badge/TypeScript-0b0b0d?style=flat-square&logo=typescript&logoColor=5ea6f8" />
    <img alt="Supabase" src="https://img.shields.io/badge/Supabase-0b0b0d?style=flat-square&logo=supabase&logoColor=5eead4" />
    <img alt="Vercel" src="https://img.shields.io/badge/Vercel-Production-0b0b0d?style=flat-square&logo=vercel&logoColor=ffffff" />
    <img alt="Node 22" src="https://img.shields.io/badge/Node-22.x-0b0b0d?style=flat-square&logo=nodedotjs&logoColor=72b77e" />
  </p>
</div>

---

## The idea

The site pairs a minimalist editorial portfolio with a protected content system. Presentation remains controlled by code; the owner can update approved content and media without editing components or risking the visual system.

> **Design contract:** content can change; components cannot.

## What it includes

| Experience | Capability |
| --- | --- |
| Public portfolio | Responsive Home, About, Projects, Research, Posts, and Contact pages |
| Research record | Publication metadata, DOI, publisher, venue, and authorship position |
| Project catalog | Categorized projects with status, tags, source visibility, and featured ordering |
| Publishing system | Drafts, scheduling, cover media, preview, tags, and revision restoration |
| Portfolio editor | Profile, portrait, CV, education, skills, coursework, thesis, and community work |
| Future-proof records | Experience, awards, hackathons, competitions, and presentations |
| Page controls | Approved Home and About section visibility and ordering |
| Site settings | Contact details, social links, SEO defaults, canonical URL, and social preview image |

The interface supports light and dark themes, keyboard navigation, reduced motion, responsive layouts, and touch-friendly controls.

## Architecture

```text
Visitor / owner
      │
      ▼
Astro 7 SSR on Vercel
      ├── Public portfolio pages
      ├── Protected owner CMS
      └── Server API routes
              │
              ├── Supabase Auth ── owner sessions
              ├── Supabase Postgres ── structured content + RLS
              ├── Supabase Storage ── portfolio and post media
              └── Resend ── validated contact delivery
```

Astro content collections provide local fallback records, while Supabase becomes the live content source when configured.

## Technology

- **Frontend:** Astro 7, TypeScript, Tailwind CSS 4
- **Rendering:** Server-side rendering through `@astrojs/vercel`
- **Data:** Supabase PostgreSQL and Row Level Security
- **Identity:** Supabase email/password authentication
- **Media:** Supabase Storage with file type and size validation
- **Email:** Resend transactional delivery
- **Typography:** Space Grotesk, Inter, and JetBrains Mono served locally
- **Deployment:** GitHub-connected Vercel production pipeline

## Routes

| Route | Purpose |
| --- | --- |
| `/` | Portfolio overview and selected work |
| `/about` | Profile, education, skills, thesis, credentials, and community |
| `/projects` | Complete project catalog |
| `/research` | Publication record and authorship metadata |
| `/posts` | Published field notes and articles |
| `/contact` | Professional links and contact form |
| `/admin/login` | Protected owner CMS entry |

## Repository map

```text
public/                  Static files, CV, icons, and social assets
src/components/         Public and CMS interface components
src/content/            Typed local fallback content
src/layouts/            Public and protected admin shells
src/lib/cms/            Supabase clients and CMS utilities
src/pages/              Portfolio, admin, and server API routes
src/styles/             Global design system
supabase/migrations/     Schema, policies, permissions, and seed data
```

## Run locally

Requires Node.js 22.x.

```bash
npm install
copy .env.example .env
npx astro dev --background
```

Open `http://localhost:4321`. Manage the background server with:

```bash
npx astro dev status
npx astro dev logs
npx astro dev stop
```

## Environment

```env
PUBLIC_SUPABASE_URL=
PUBLIC_SUPABASE_PUBLISHABLE_KEY=
RESEND_API_KEY=
CONTACT_FROM_EMAIL=
```

Keep real values in `.env` locally and in Vercel Environment Variables for deployment. `.env` and `.vercel` are excluded from version control.

`CONTACT_FROM_EMAIL` must use a verified Resend domain for unrestricted production delivery.

## Supabase bootstrap

1. Create a Supabase project and enable email/password authentication.
2. Run `supabase/migrations/` in filename order.
3. Create the owner in Supabase Authentication.
4. Insert the owner UUID into `public.cms_admins`.
5. Add local and production URLs under Authentication URL Configuration.

Row Level Security is the final authorization boundary: visitors read only published or visible records; approved CMS administrators can create, update, and delete content.

## Quality gates

```bash
npx astro check
npm run build
npm audit
```

The production branch is `main`. Every push to `main` triggers a new Vercel production deployment; other Git branches create preview deployments.

## Security model

- Owner-only CMS routes and API operations
- Explicit database grants backed by Row Level Security
- No service-role key in the browser or repository
- Validated media types and upload size limits
- Escaped and rate-limited contact submissions with honeypot protection
- Design-safe structured fields instead of arbitrary HTML, CSS, or scripts
- Secrets and local deployment metadata excluded from Git

## Content still evolving

- Confirm remaining project source and live URLs
- Verify selected coursework against the final transcript
- Add future roles, awards, hackathons, competitions, and presentations through the CMS

---

<div align="center">
  <sub>Designed and built by <strong>Sabit Al Alfi</strong> · Built with clarity and care.</sub>
</div>
