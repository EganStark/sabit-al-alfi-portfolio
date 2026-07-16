# Sabit Al Alfi — Portfolio & CMS

A research-led personal portfolio for Data Science, explainable AI, academic work, and practical software engineering. The public presentation is protected by a code-owned design system, while structured content is managed through a secure owner-only CMS.

## Highlights

- Responsive, accessible portfolio with light and dark themes
- Complete project and peer-reviewed publication catalogs
- Permanent posts section with drafts, scheduling, previews, and revision history
- Owner CMS for profile, projects, research, education, skills, certifications, thesis, community work, contact details, SEO, and media
- Configurable Home and About section visibility and ordering
- Supabase Authentication, Storage, PostgreSQL, and Row Level Security
- Validated contact delivery through Resend
- Astro SSR deployment optimized for Vercel

## Stack

- Astro 7 server rendering with the Vercel adapter
- TypeScript and Tailwind CSS 4 integration
- Supabase Postgres, Authentication, Storage, and Row Level Security
- Resend transactional email delivery
- Local Space Grotesk, Inter, and JetBrains Mono fonts

## Routes

| Route | Purpose |
| --- | --- |
| `/` | Portfolio overview and CMS-synchronized selected work |
| `/about` | Profile, skills, thesis, education, credentials, and community |
| `/projects` | Complete project catalog |
| `/research` | Publication record and authorship metadata |
| `/posts` and `/posts/[slug]` | Published posts and articles |
| `/contact` | Professional profiles and contact form |
| `/admin/login` | Protected owner CMS |

The CMS can change approved content and media but cannot inject CSS, scripts, or arbitrary page structure. That boundary keeps editorial updates from damaging the portfolio design.

## Project structure

```text
public/                  Static files, portrait, CV, and social assets
src/components/         Reusable public and CMS interface components
src/content/            Local fallback content
src/layouts/            Public and protected admin layouts
src/lib/cms/            Supabase clients and CMS utilities
src/pages/              Portfolio, admin, and API routes
src/styles/             Global design system
supabase/migrations/     Database schema, policies, permissions, and seed data
```

## Local development

Requires Node.js 22.12 or newer.

```sh
npm install
npx astro dev --background
```

The site runs at `http://localhost:4321`. Manage it with `npx astro dev status`, `npx astro dev logs`, and `npx astro dev stop`.

## Environment

Copy `.env.example` to `.env`. Never commit `.env` or expose its values in client-side code.

```env
PUBLIC_SUPABASE_URL=
PUBLIC_SUPABASE_PUBLISHABLE_KEY=
RESEND_API_KEY=
CONTACT_FROM_EMAIL=
```

`CONTACT_FROM_EMAIL` must use a verified Resend domain in production. For initial testing, use `Portfolio <onboarding@resend.dev>` and the email associated with the Resend account as recipient.

## Supabase setup

1. Create a Supabase project and enable email/password authentication.
2. Run every file in `supabase/migrations/` in filename order.
3. Create the owner in Supabase Authentication.
4. Add the owner UUID to `public.cms_admins`.
5. Add the local and production site URLs to the Supabase Authentication redirect settings.

Row Level Security is the final authorization boundary: visitors can read published/visible content, while authenticated CMS administrators can create and update records.

## Quality checks

```sh
npx astro check
npm run build
npm audit
```

## Deployment

1. Import the repository into Vercel or deploy with the Vercel CLI.
2. Add every variable from `.env.example` to the Vercel project.
3. Deploy using the Astro framework preset and Node.js 22.
4. Add the production URL to Supabase Authentication.
5. Set the canonical production URL in **CMS → Settings & media**.
6. Verify public content, CMS authentication and CRUD, uploads, contact delivery, metadata, and mobile layouts.

## Security notes

- Secrets and local Vercel metadata are excluded from version control.
- CMS routes require an authenticated user listed in `cms_admins`.
- Database writes are protected by explicit grants and Row Level Security policies.
- Uploaded media is type- and size-validated.
- Contact submissions are validated, escaped, honeypot-protected, and rate-limited.

## Remaining content confirmations

- Verify coursework against the transcript.
- Add confirmed source/live URLs for projects with unconfirmed links.
- Add future awards, hackathons, competitions, and presentations through the CMS.
