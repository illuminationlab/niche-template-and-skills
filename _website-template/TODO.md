# NeedleMoved Website - TODO & Asset Requirements

## Status: In Progress
Last updated: April 15, 2026

Source content plan: `/Users/ryangough/Downloads/NeedleMoved_Full_Content_SEO_Plan.md`
Template reference (structure): `/Users/ryangough/Desktop/IL Campbell Website/TODO.md`

---

## OPEN QUESTIONS (Need Your Input)

### Branding
- [ ] **Company name confirmation** - Using "NeedleMoved" throughout. Confirm product/brand name is final.
- [ ] **Logo** - Need final logo files (SVG preferred, plus PNG fallback)
  - Header logo: ~293x46px (SVG)
  - Favicon: 32x32px and 270x270px (for Apple touch icon)
  - Footer logo: same as header
- [ ] **Brand colors** - Propose: clinical/aesthetic palette (soft neutrals + accent). Confirm or adjust.
- [ ] **Tagline** - Currently using "The all-in-one growth platform built exclusively for med spas." Confirm or change.

### Business Details
- [ ] **Company address** - Need physical address for footer
- [ ] **Phone number** - For header and contact sections
- [ ] **Email** - Contact email for footer (e.g., hello@needlemoved.com)
- [ ] **Social media URLs** - Facebook, Instagram, LinkedIn, YouTube (placeholder # links currently)

### Pricing
- [ ] **Pricing tiers / base fee amount** - Pricing page uses "base platform fee + usage-based" model. Need the actual base fee $ amount to publish.
- [ ] **Usage rate card** - Per-minute Voice AI rate, per-token Conversation AI rate, per-SMS rate, per-email rate to display publicly (or keep "pennies per call" language only).
- [ ] **Free trial length** - "Start Free Trial" CTA is referenced throughout. Confirm trial duration (7/14/30 days?).
- [ ] **Stripe signup link** - One generic Stripe link used on every niche site (per your note). Need the URL.

### Legal
- [ ] **Privacy Policy** - Need content or template (HIPAA-aware; med spa context)
- [ ] **Terms of Service** - Need content or template
- [ ] **Cookie Policy** - Need content or approach
- [ ] **HIPAA / BAA language** - Confirm how we represent HIPAA compliance on-site

### Integrations
- [ ] **Which integrations to highlight?** - Suggested: Google (Ads/Business Profile), Meta (FB/IG Ads), Stripe, Twilio / LC Phone, WhatsApp, Zapier, QuickBooks, Google Calendar, Mailgun/SendGrid
- [ ] **Integration partner logos** - Need permission/logos for each

### Forms & Webhooks
- [ ] **Single shared webhook across niches** - All contact forms on all niche sites post to the same webhook. Need the production URL.
  - Shared fields: Name, Business Name, Email, Phone, "What are you looking for?" (dropdown)
  - Hidden field: `source_site` = `needlemoved` (so the webhook can route per niche)
  - Hidden field: `form_location` = e.g. `home-hero`, `contact-page`, `demo-modal`, `exit-intent` (for analytics)
- [ ] **Form notification emails** - Where should NeedleMoved form submissions be routed after the webhook receives them?
- [ ] **Newsletter signup** - Same webhook or separate (e.g., ESP like Mailchimp/ConvertKit)? Same pattern: hidden `source_site` field.

---

## ASSETS NEEDED

### Photography / Images

#### Hero & Section Images
| Page | Description | Dimensions | Notes |
|------|-------------|------------|-------|
| Homepage | Hero image — modern med spa interior / injector with patient | 1200x800px | Warm, clinical, premium feel |
| Homepage | "AI front desk" section visual — Voice AI dashboard mock | 600x450px | Calls/transcripts UI |
| Homepage | Platform/CRM screenshot | 600x450px | Patient pipeline view |
| Features - Voice AI | Voice AI call dashboard / transcript | 600x450px | Greeting config, voices, outcomes |
| Features - Conversation AI | Unified inbox screenshot | 600x450px | SMS/DM/chat all in one |
| Features - AI Workflow Builder | Workflow diagram UI | 600x450px | Visual triggers/actions |
| Features - Funnel/Website Builder | Landing page builder UI | 600x450px | Drag-and-drop |
| Features - Content AI | Copy generation UI | 600x450px | Email/SMS/social generators |
| Features - Reputation AI | Reviews dashboard | 600x450px | Google reviews + AI responses |
| Features - CRM | Pipeline view | 600x450px | Lead → consult → booked → repeat |
| Features - Scheduling | Calendar/booking UI | 600x450px | Provider + room availability |
| Features - Analytics | Revenue/attribution dashboard | 600x450px | Revenue by provider, CPL, no-show rate |
| Features - Membership | Membership portal UI | 600x450px | Tiered plans, billing |
| Features - Payments | Invoice/payment UI | 600x450px | Card on file, recurring billing |
| Features - Mobile App | White-label app mockup | 600x900px | Phone frame |
| Use Cases | Solo owner lifestyle shot | 1200x600px | Injector at work |
| Use Cases | Front desk team photo | 1200x600px | Busy front desk |
| Use Cases | Multi-location / map visual | 1200x600px | Growth/scale imagery |
| Pricing | Pricing hero (optional) | 1200x600px | Clean, minimal |
| About | Team/office lifestyle photo | 1200x600px | Team collaboration |
| Contact | Contact hero (optional) | 1200x600px | Friendly, human |

#### Use Case Hero Images (equivalent to "Industry Hero Images" in template)
| Use Case | Description | Dimensions | Notes |
|----------|-------------|------------|-------|
| The Solo Owner Wearing Every Hat | Single injector running practice | 600x450px | Warm, authentic |
| The Front Desk Drowning in Tasks | Receptionist juggling calls/DMs | 600x450px | Busy, realistic |
| The Multi-Location Practice Scaling Fast | Multi-location / map / storefronts | 600x450px | Growth feel |
| The Practice Manager Trying to Prove Marketing ROI | Manager at laptop w/ dashboard | 600x450px | Professional |
| The Med Spa Losing Patients After First Visit | Patient leaving / rebooking | 600x450px | Retention theme |
| The New Med Spa Trying to Fill a Schedule from Zero | New space / grand opening | 600x450px | Fresh, launch feel |

#### Team Photos
| Person | Dimensions | Notes |
|--------|------------|-------|
| Founder/CEO | 400x400px (circle crop) | Professional headshot + short bio |
| Team Member 2 (Customer Success) | 200x200px (circle crop) | Headshot + one-sentence bio |
| Team Member 3 (Product) | 200x200px (circle crop) | Headshot + one-sentence bio |
| Team Member 4 (Growth) | 200x200px (circle crop) | Headshot + one-sentence bio |

#### Testimonial Photos
| Person | Dimensions | Notes |
|--------|------------|-------|
| Homepage testimonial client | 56x56px (circle crop) | Name, title, practice, city — placeholder |
| 3–5 additional testimonial clients | 56x56px (circle crop) | Spread across Use Cases & Features pages |
| Client practice logo bar | Height: 40px (SVG) | 4–6 med spa client logos for homepage |

#### Resource Cover Images
| Resource | Dimensions | Notes |
|----------|------------|-------|
| "The 2026 Med Spa Marketing Playbook" cover | 400x520px | 15–20 page PDF guide |
| "Med Spa Revenue Calculator" graphic | 400x520px | Interactive tool thumbnail |
| "From Signup to Booked Appointments" getting-started guide cover | 400x520px | 30-day onboarding guide |

#### Blog Post Thumbnails
| Post | Dimensions | Notes |
|------|------------|-------|
| 4 featured blog thumbnails (see Content section) | 400x240px | Topic-relevant imagery |

#### Integration Partner Logos
| Partner | Dimensions | Notes |
|---------|------------|-------|
| Google | Height: 28px (SVG) | Grayscale by default |
| Meta (Facebook/Instagram) | Height: 28px (SVG) | Grayscale by default |
| Stripe | Height: 28px (SVG) | Grayscale by default |
| Twilio / LC Phone | Height: 28px (SVG) | Grayscale by default |
| WhatsApp | Height: 28px (SVG) | Grayscale by default |
| Zapier | Height: 28px (SVG) | Grayscale by default |
| QuickBooks | Height: 28px (SVG) | Grayscale by default |
| Google Calendar | Height: 28px (SVG) | Grayscale by default |

### Video Content
- [ ] **Product demo video** - For homepage hero "See How It Works" CTA (~2-3 min overview)
- [ ] **Voice AI live demo** - Short clip of a real inbound AI call (~60-90 sec)
- [ ] **Conversation AI demo** - SMS/DM/chat flow walkthrough (~60-90 sec)
- [ ] **Feature demo clips** - Short clips per Features section (CRM, Workflow Builder, Funnels, Content AI, Reputation AI)
- [ ] **Client testimonial videos** - Video versions of written testimonials
- [ ] **"How It Works in 3 Steps" explainer** - Animated walkthrough of the homepage 3-step flow

### Graphics / Illustrations
- [ ] **Custom SVG icons** per Features card (Voice AI, Conversation AI, CRM, Scheduling, Automation, Reputation, Payments, Membership, Funnels, Ads, Mobile App, Affiliate)
- [ ] **Comparison table visual** - "5 Separate Tools vs NeedleMoved" graphic for Homepage + Pricing
- [ ] **"How it Works" 3-step infographic** - Homepage
- [ ] **ROI math visual** - Pricing page ($52K recovered, 40% fewer no-shows, etc.)
- [ ] **Med spa-specific illustrations** - neurotoxin / filler / laser / body contouring iconography

---

## CONTENT TO CREATE

### Source-of-truth content
All long-form page copy already drafted in `/Users/ryangough/Downloads/NeedleMoved_Full_Content_SEO_Plan.md`. Pages below reference the section in that plan.

### Resources (Not Yet Created)
- [ ] **Lead Magnet PDF**: "The 2026 Med Spa Marketing Playbook"
  - 15–20 page guide: 5 highest-ROI channels, budget allocation, automation workflows, email/SMS templates, 90-day marketing calendar
  - Landing page + gated download form (same webhook, hidden `form_location=playbook`)
- [ ] **Lead Magnet Tool**: "The Med Spa Revenue Calculator"
  - Interactive: avg appt value, daily call volume, missed-call rate, no-show rate → estimated annual loss + recovery projection
  - Email-gated results delivery (same webhook, hidden `form_location=revenue-calculator`)
- [ ] **Getting Started Guide**: "From Signup to Booked Appointments: Your First 30 Days with NeedleMoved"
  - Sections 1–5 outlined in source plan (Setup → AI Training → Automations → First Campaign → Measure)

### Blog Posts (4 featured, per source plan)
- [ ] **Post 1** — "How AI Is Transforming Med Spa Operations — From Reception to Revenue"
  - Target keyword: *AI in medical aesthetics*
- [ ] **Post 2** — "7 Proven Strategies to Reduce No-Shows at Your Med Spa and Recover $7,500 Per Month"
  - Target keyword: *how to reduce no-shows at a med spa*
- [ ] **Post 3** — "The Med Spa Tech Stack Problem — Why 5 Tools Cost More Than One Platform"
  - Target keyword: *best CRM for med spa*
- [ ] **Post 4** — "Med Spa Client Retention — 10 Strategies to Turn First-Time Visitors Into Loyal Patients"
  - Target keyword: *med spa client retention strategies*
- [ ] Need individual blog post template page

### Case Studies
- [ ] No dedicated case studies section built yet. Consider adding:
  - `/case-studies/` index page
  - Individual case study pages for real clients
  - Current testimonials are placeholders — replace with real client stories (40% more consultations in 90 days quote, etc.)

### Newsletter
- [ ] Newsletter signup block (footer + Resources page)
  - Headline/body copy drafted in source plan
  - Decide ESP (Mailchimp / ConvertKit / shared webhook)

---

## TECHNICAL TODO

### SEO & Meta
- [ ] Meta titles + descriptions per page (already drafted in source plan — copy verbatim)
- [ ] Primary/secondary keywords per page (already mapped in source plan SEO table)
- [ ] Internal link plan per page (source plan lists suggestions per page)
- [ ] Add Open Graph meta tags to all pages
- [ ] Add Twitter Card meta tags
- [ ] Create sitemap.xml
- [ ] Create robots.txt
- [ ] Add structured data — Organization, Product (SoftwareApplication), FAQPage (pricing + contact FAQs), Article (blog posts)
- [ ] LocalBusiness schema *only if* a physical HQ is listed

### Performance
- [ ] Minify CSS and JS for production
- [ ] Optimize and compress all images (WebP format)
- [ ] Add lazy loading to below-fold images
- [ ] Implement critical CSS inlining
- [ ] Add preload hints for key resources

### Analytics & Tracking
- [ ] Google Analytics 4 setup
- [ ] Google Tag Manager setup
- [ ] Facebook Pixel (Meta)
- [ ] Conversion tracking on all forms (shared webhook → route events by `source_site`)
- [ ] Heatmap tool (Hotjar / Microsoft Clarity)
- [ ] Call tracking numbers (Twilio / LC Phone) for attribution

### Deployment (GitHub → Coolify → needlemoved.com)
- [ ] **GitHub repo** - This repo (`/Users/ryangough/Desktop/repos/NeedleMoved`) — initialize and push to remote on GitHub
- [ ] **Coolify application** - Create a new application in Coolify connected to the GitHub repo
  - Static site build (if vanilla HTML/CSS/JS) or Node/framework build if we choose one
  - Auto-deploy on push to `main`
- [ ] **Domain** - Point `needlemoved.com` (already purchased) DNS → Coolify server IP
  - A record `@` → Coolify host
  - CNAME `www` → `@` (or Coolify's provided hostname)
- [ ] **SSL** - Enable Let's Encrypt in Coolify for `needlemoved.com` + `www.needlemoved.com`
- [ ] **Environment variables in Coolify** - `WEBHOOK_URL`, `SOURCE_SITE=needlemoved`, analytics IDs, Stripe link, etc.
- [ ] **CDN** - Coolify + Cloudflare in front (optional but recommended)
- [ ] **Email (form notifications)** - Configure inbound routing from shared webhook

### Accessibility
- [ ] Full WCAG 2.1 AA audit
- [ ] Keyboard navigation testing
- [ ] Screen reader testing
- [ ] Color contrast verification
- [ ] Alt text for all images

---

## PAGES TALLY

NeedleMoved is a 7-page site (per source plan), vs IL Campbell's 21+ page structure. Map below preserves the template's tracking format but reflects NeedleMoved's actual page count. Each row references the section of the source plan that contains the page copy.

| Page | Status | Path | Source Plan Reference |
|------|--------|------|----------------------|
| Homepage (Overview) | ❌ Not built | `/index.html` | Source plan — "Page 1: Overview (Homepage)" (lines 25–135) |
| Features | ❌ Not built | `/features.html` | Source plan — "Page 2: Features" (lines 138–349) |
| Use Cases | ❌ Not built | `/use-cases.html` | Source plan — "Page 3: Use Cases" (lines 352–468) |
| Resources Hub | ❌ Not built | `/resources/index.html` | Source plan — "Page 4: Resources" (lines 471–663) |
| Blog (index) | ❌ Not built | `/resources/blog.html` | Source plan — "Featured Blog Posts" (lines 490–614) |
| Blog Post 1 — AI in Medical Aesthetics | ❌ Not built | `/resources/blog/ai-medical-aesthetics.html` | Source plan — Blog Post 1 outline (lines 492–514) |
| Blog Post 2 — Reduce No-Shows | ❌ Not built | `/resources/blog/reduce-no-shows.html` | Source plan — Blog Post 2 outline (lines 518–546) |
| Blog Post 3 — Med Spa Tech Stack | ❌ Not built | `/resources/blog/med-spa-tech-stack.html` | Source plan — Blog Post 3 outline (lines 550–572) |
| Blog Post 4 — Client Retention | ❌ Not built | `/resources/blog/client-retention.html` | Source plan — Blog Post 4 outline (lines 576–613) |
| Revenue Calculator (lead magnet) | ❌ Not built | `/resources/revenue-calculator.html` | Source plan — "Lead Magnet 1" (lines 642–646) |
| Marketing Playbook (lead magnet) | ❌ Not built | `/resources/playbook.html` | Source plan — "Lead Magnet 2" (lines 648–652) |
| Getting Started Guide | ❌ Not built | `/resources/getting-started.html` | Source plan — "Getting Started Guide" (lines 617–636) |
| Pricing | ❌ Not built | `/pricing.html` | Source plan — "Page 5: Pricing" (lines 666–763) |
| About Us | ❌ Not built | `/about.html` | Source plan — "Page 6: About Us" (lines 766–846) |
| Contact Us | ❌ Not built | `/contact.html` | Source plan — "Page 7: Contact Us" (lines 850–915) |
| Book a Demo | ❌ Not built | `/book-demo.html` | Reuses Contact form — hidden `form_location=book-demo` |
| Start Free Trial (Stripe) | N/A — external | Stripe link | Single generic Stripe link reused across all niche sites |
| Privacy Policy | ❌ Not built | `/privacy.html` | — |
| Terms of Service | ❌ Not built | `/terms.html` | — |
| Case Studies | ❌ Not built | `/case-studies/*.html` | — (no source copy yet; placeholder testimonials in plan) |

**Total pages: 0 built / 19 planned**

### Notes on mapping vs. IL Campbell template
- IL Campbell's **Services** (7 sub-pages) and **Industries** (5 sub-pages) do **not** have 1:1 equivalents in NeedleMoved. Instead:
  - IL Campbell Services ⇨ NeedleMoved **Features** (single page with anchor sections: Voice AI, Conversation AI, AI Workflow Builder, Funnel Builder, Content AI, Reputation AI, CRM, Scheduling, Marketing, Automation, Patient Experience).
  - IL Campbell Industries ⇨ NeedleMoved **Use Cases** (single page with anchor sections: Solo Owner, Front Desk, Multi-Location, Practice Manager, Retention, New Med Spa).
  - If/when we want sub-pages for SEO, we can split each Feature and each Use Case into its own page using the exact copy blocks from the source plan.
- IL Campbell has a dedicated **Book a Demo** page; NeedleMoved reuses the Contact form with a hidden `form_location` field.
- IL Campbell has separate **E-Book** and **Marketing Playbook** landing pages; NeedleMoved equivalents are the **Marketing Playbook** and **Revenue Calculator** lead magnets.

---

## FORMS — SHARED WEBHOOK SPEC (applies to every niche site, not just NeedleMoved)

All contact/lead forms across all niche sites POST to the same webhook. Consistent field schema + hidden `source_site` lets the webhook route by niche.

**Shared fields (all forms):**
- `name` (required)
- `business_name` (required)
- `email` (required)
- `phone` (required)
- `intent` (dropdown — matches source plan options: demo / free trial / pricing / switching / new med spa / other)
- `message` (optional long-text — only on generic contact form)

**Hidden fields (all forms):**
- `source_site` = `needlemoved`  *(per niche: `ilcampbell`, `needlemoved`, etc.)*
- `form_location` = e.g. `home-hero` | `contact-page` | `book-demo` | `playbook-download` | `revenue-calculator` | `newsletter` | `exit-intent`
- `page_url` = `window.location.href` (captured client-side)
- `utm_source` / `utm_medium` / `utm_campaign` / `utm_term` / `utm_content` (from URL)
- `referrer` = `document.referrer`
- `submitted_at` = ISO timestamp

**Stripe signup:** A single generic Stripe link ("Start Free Trial" / "Get Started") is reused across every niche site — no per-niche signup form required. The Stripe product label stays niche-neutral (e.g. "NeedleMoved Platform Access" — not "Med Spa Starter Plan") so the same URL works everywhere.

---

## STATS TO VERIFY (Currently Placeholder / Industry-Sourced)

All statistics on the site come from the source plan. Before launch, verify each against a citable source or replace with NeedleMoved's own data.

| Stat | Current Value | Location | Notes |
|------|---------------|----------|-------|
| Voicemail non-return rate | 85% | Homepage hero, Features, Use Cases | Cite source |
| Annual revenue lost to missed calls | $250,000 | Homepage | Based on 2 missed calls/day × $500 avg ticket |
| Avg appointment ticket | $500 | Homepage, Pricing ROI math | Confirm industry benchmark |
| Marketing automation adoption | 18% of med spas | Homepage | Cite source |
| CRM adoption | 35% of med spas | SEO summary | Cite source |
| No-show reduction via reminders | up to 40% | Multiple pages | Cite source |
| Speed-to-lead conversion lift | 10x within 5 min | Multiple pages | Cite source |
| Touchpoints to book | 5–7 | Homepage | Cite source |
| Repeat-patient share of revenue | 73% | Homepage, Retention use case | Cite source |
| Members visit frequency | 2.9x non-members | Homepage, Membership | Cite source |
| Members spend lift | 35% more | Retention blog | Cite source |
| SMS vs email open rate | 98% vs 20% | Features — Two-Way SMS | Cite source |
| Med spa market size | $118.1M software / $20B industry | SEO summary, About | Cite sources |
| CAGR | 13.6% | SEO summary | Cite source |
| Total US med spas | 11,500+ | Homepage, About | Cite source |
| US med spa employees | 100,000+ | About | Cite source |
| Avg no-show rate | 23–34% | Blog Post 2 | Cite source |
| Per-missed-appt loss | $196 | Blog Post 2 | Cite source |
| Retention profit impact | 5% retention ↑ = 25–95% profit ↑ | Blog Post 4 | Cite source |
| Avg patient lifetime value | $7,800+ | Blog Post 4 | Cite source |
| Stack cost savings | 40–70% | Pricing | Our calculation vs stack — keep or soften |

---

## NOTES

- Source-of-truth content: `/Users/ryangough/Downloads/NeedleMoved_Full_Content_SEO_Plan.md` (919 lines) — every bit of that plan is covered in the page mapping above.
- Structural template: IL Campbell's TODO.md — this doc mirrors that layout so all niche sites are tracked consistently.
- Tech choice: match IL Campbell's stack (vanilla HTML/CSS/JS, dark-theme + accent) for now so niche sites stay portable and easy to drop into Coolify as static builds. Revisit if we want a framework later.
- Forms: single shared webhook across all niches with hidden `source_site` field — do NOT build per-niche webhook endpoints.
- Stripe: single generic signup link across all niches — keep the Stripe product label niche-neutral.
- Testimonials, client logos, and team bios are all placeholders in the source plan — replace before launch.
- HIPAA positioning: source plan mentions "HIPAA compliant" in several places. Before publishing, confirm our actual compliance posture and BAA availability — do not overclaim.
- Mobile responsive + scroll-reveal animations expected (carry over from IL Campbell template patterns).
