# Deep-Research Prompt — [WEBSITE_NAME]

This is the prompt template used by `/niche-research` to generate a full content + SEO plan for a new niche site. Fill every `[BRACKET]`, then either run it in claude.ai Deep Research (human-in-loop) or let the `/niche-research` skill execute it via a research subagent.

---

You are an expert SaaS copywriter and SEO strategist. Your task is to conduct deep research on the `[NICHE]` industry and produce a complete, SEO-optimized content plan and full page copy for a CRM and marketing platform called `[WEBSITE_NAME]` (website: `[WEBSITE_URL]`).

The product is powered by Go High Level (GHL) — a full-stack, all-in-one AI-powered platform — but `[WEBSITE_NAME]` is white-labeled and positioned exclusively for `[NICHE]` businesses. Reference the full GHL feature set freely. The positioning and tone should mirror how firmpilot.com presents a CRM for law firms — but rebuilt for `[NICHE]`.

---

## PRODUCT OVERVIEW

`[WEBSITE_NAME]` is an all-in-one growth platform built exclusively for `[NICHE]` businesses. It combines every tool a modern `[NICHE]` business needs into a single system — no disconnected apps, no missing pieces.

Core platform features include:
- CRM & Lead Pipeline Management
- Scheduling, Booking & Appointments
- Email Marketing & Campaigns
- Two-Way SMS & Messaging
- Automation Workflows
- Call Tracking & Recording
- Reputation Management (Review Requests & Responses)
- Tracking & Analytics Dashboards
- Document Signing
- Funnels & Landing Pages
- Membership & Course Portals
- Social Media Planner
- Invoicing & Payments
- Affiliate Manager
- White-label Mobile App
- Missed Call Text-Back
- Broadcast Campaigns (Email / SMS / WhatsApp / Messenger)
- Ad Manager (Google, Facebook, Instagram)
- AI-Powered Workflow Builder (describe it, AI builds the triggers, actions, and IF/THEN logic)
- Funnel & Website AI Builder (generate full pages from a prompt)
- Content AI (on-brand copy, images, and ideas in seconds)
- Reputation AI (auto-responds to reviews with a natural, human-like tone)

This is a no-limitations, full GHL-powered stack.

---

## AI FEATURES — EXPLAIN THESE IN DETAIL THROUGHOUT THE COPY

`[WEBSITE_NAME]` includes two distinct AI tools that work together to make sure no lead, call, or question ever goes unanswered. Describe both fully in the Features page and reference them naturally across other pages.

### Voice AI (Phone-Based AI Receptionist)

Voice AI acts as a 24/7 AI receptionist for `[NICHE]` businesses — answering inbound calls, handling inquiries, and taking real action so nothing falls through the cracks after hours or during busy periods.

What Voice AI can do during a call:
- Answer inbound calls and greet callers naturally using advanced speech recognition and natural language understanding
- Respond to questions using a custom knowledge base trained on the business's services, FAQs, hours, and policies
- Create, schedule, edit, reschedule, or cancel appointments — it sees the live calendar and suggests open slots instantly
- Create new contacts and opportunities directly inside the CRM from the call
- Collect and update contact information (name, email, phone, service interest) and save it to the contact record
- Take notes from the call and pass them along to the admin or owner
- Trigger automated workflows mid-call or after the call ends (e.g. send a follow-up SMS, notify a team member, add to a pipeline stage)
- Transfer the call to a live human agent when escalation is needed or a high-intent signal is detected
- Send an SMS to the caller during or after the call (e.g. confirmation link, payment link, follow-up info)
- Make outbound calls automatically — follow up with new leads seconds after a form fill, send appointment reminders, re-engage cold leads — all hands-free from a workflow trigger

Additional Voice AI capabilities:
- Fully customizable: choose from 200+ voices, set tone, language, pace, and personality to match the brand
- Custom prompts and agent goals let you define exactly how the AI behaves and what it prioritizes
- After-hours configuration: set what happens when a call comes in outside business hours (voicemail, alternate number, or AI continues)
- Post-call summaries and sentiment scores are automatically logged in the dashboard
- Works on both LC Phone and Twilio numbers
- A Voice AI Chat Widget can also be embedded directly on the website — visitors click a mic icon and speak to the AI agent live in their browser, no phone call or app required. The widget can be placed as a floating bubble or embedded inline within page content (e.g. under a hero section or next to a CTA)

### Conversation AI (Website Chat Widget & Multi-Channel Messaging Bot)

Conversation AI is the intelligent chat assistant that lives on the `[WEBSITE_NAME]` website widget and inside every messaging channel — SMS, email, Facebook Messenger, Instagram DMs, WhatsApp, and live chat. It engages visitors and leads 24/7 with natural, human-like responses.

What Conversation AI can do:
- Answer any question a website visitor asks, pulling answers directly from a custom knowledge base that the business owner can add to, edit, or update at any time
- Qualify incoming leads by collecting their name, contact info, service interest, and other key details through natural conversation
- Book appointments directly within the chat flow
- Escalate the conversation to a live admin or owner when the visitor requests it or the situation requires a human touch
- Respond to inbound SMS, DMs, and messages across all connected channels — keeping the conversation going wherever the lead is
- Understand audio messages — visitors can speak on mobile and the AI detects intent, extracts key details, and responds appropriately
- Maintain context across a conversation so responses feel coherent and natural, not robotic
- Connect to additional knowledge sources: documents, FAQs, imported website data via web crawler, and custom-uploaded files
- Operate in a suggestive mode (where it drafts responses for a human to approve) or fully automated mode (where it handles the conversation end-to-end)
- Works inside the same unified inbox as all other conversations — SMS, email, DMs, and live chat all appear in one place

---

## PRICING MODEL

Summarize pricing using the locked tiers below (already reconciled from internal Notion pricing doc). Do NOT reference free trials anywhere. `FREE_TRIAL = NO`.

- Tier 1 — Starter: **$99/month**
- Tier 2 — Growth: **$199/month** (Most Popular)
- Tier 3 — Professional: **$299/month**
- One-time setup fee: **$200** (bundled into Stripe checkout)

Framing for the Pricing page:
- The base price covers platform/system access
- Each feature has its own usage-based cost — you only pay for what you use (calls, SMS, emails, AI minutes, etc.)
- Position this as affordable and transparent — ideal for growing `[NICHE]` businesses
- Emphasize no bloated bundles; clients scale their costs with their usage
- Note that Voice AI pricing includes a per-minute voice engine cost plus token-based LLM usage — frame this as "pennies per call" in context
- Note that Conversation AI is transitioning to token-based pricing — frame as pay-for-what-you-use
- Do NOT publish specific per-use rates in the copy

---

## RESEARCH INSTRUCTIONS

Before writing any copy, conduct deep research on:

1. The biggest pain points `[NICHE]` businesses face with client management, lead generation, and follow-up
2. The language and terminology `[NICHE]` professionals use (search forums, Reddit, industry blogs, reviews of tools they already use)
3. Top competitor tools already used in this niche and what they're missing
4. Common objections to switching software
5. High-value SEO keywords specific to `[NICHE]` + CRM / marketing automation / AI receptionist / booking software

Use your findings to inform every page's messaging, headlines, and keyword strategy. The copy should feel like it was written by someone who deeply understands `[NICHE]` — not generic SaaS copy with the niche name swapped in.

---

## DELIVERABLE: 7-PAGE CONTENT & SEO PLAN

Produce complete, publish-ready copy for each page below. For each page include:

- Primary SEO keyword + 3–5 secondary keywords
- Meta title (under 60 chars) and meta description (under 160 chars)
- Full page copy with H1, H2s, H3s, and body text
- Internal link suggestions between pages
- One CTA recommendation per section

### PAGE 1 — OVERVIEW (Homepage)

Goal: Communicate the value of an all-in-one AI-powered platform built specifically for `[NICHE]`.

- Lead with the #1 pain point you discovered in your research
- Hero section: bold H1 + subheadline + primary CTA
- 3–4 benefit blocks (outcomes, not feature lists)
- Mention both Voice AI and Conversation AI naturally — frame as "your business never misses a call or a question again"
- Social proof placeholder section (testimonials — use first name + last initial + city only, qualitative quotes, no fabricated stats, no specific business names)
- How it works (3-step simple flow)
- Bottom CTA banner

### PAGE 2 — FEATURES

Goal: Showcase every GHL feature — including all AI tools — framed around `[NICHE]` workflows.

- Organize features into logical categories (Communication, Automation, AI Tools, Analytics, Marketing)
- Give the AI Tools their own dedicated section with full descriptions of Voice AI and Conversation AI as outlined above
- For each non-AI feature: name, 1-line `[NICHE]`-specific benefit, and a "so you can…" outcome statement
- Include a comparison table: "Using 5 separate tools" vs "`[WEBSITE_NAME]`" — show time, cost, and complexity savings
- CTA: "Book a Demo" or "See Pricing" (NOT "Start free trial")

### PAGE 3 — USE CASES (Niche-Specific)

Goal: Speak directly to 4–6 specific roles or scenarios within `[NICHE]`.

- Use your research to identify the most common business types or roles inside this niche
- Each use case: 1 headline, 1 short scenario paragraph, 3–4 bullet outcomes, 1 CTA
- Where relevant, show how Voice AI or Conversation AI solves a specific scenario (e.g. "after-hours calls handled automatically")

### PAGE 4 — RESOURCES

Goal: SEO-rich hub for `[NICHE]` business education and thought leadership.

- Write 4 blog post outlines (title, meta description, 5-section outline each) targeting long-tail keywords
- At least 1 blog post should target an AI-related search (e.g. "AI receptionist for `[NICHE]`" or "how to automate follow-up for `[NICHE]`")
- Include a "Getting Started Guide" section outline
- Suggest 2 lead magnet ideas relevant to `[NICHE]` (e.g. checklist, template, ROI calculator)
- CTA: Newsletter signup or free resource download

### PAGE 5 — PRICING

Goal: Transparent, low-friction pricing page that reduces objections and builds trust.

- Explain the base platform cost + usage-based model clearly
- Include a plain-language breakdown of how AI feature costs work (framed positively — "only pay when it's working for you")
- FAQ section: top 5 pricing objections for `[NICHE]` buyers
- Comparison: `[WEBSITE_NAME]` vs. paying for separate tools — show realistic cost savings
- "What's included in base" list and "Pay-as-you-go" feature list
- CTA: "Book a Demo" or "Sign Up Now" (NOT "Start free trial")

### PAGE 6 — ABOUT US

Goal: Build trust with `[NICHE]` business owners by showing deep niche expertise.

- Opening: We built `[WEBSITE_NAME]` because we saw that `[NICHE]` businesses were being underserved by generic CRM tools
- Brand story: We focus ONLY on `[NICHE]` — this is our entire world
- Mission statement: Help `[NICHE]` businesses grow affordably with tools built for how they actually work
- Values section (3–4 values with short descriptions)
- Team/founder placeholder section
- CTA: "Join hundreds of `[NICHE]` businesses" (adjust phrasing as appropriate)

### PAGE 7 — CONTACT US

Goal: Low-friction page that converts visitors into leads or demos.

- Headline + 1–2 sentence copy
- Contact form fields: First Name, Last Name, Business Name, Email, Phone, "What are you looking for?" (dropdown), Message
- "Book a Demo" option (connects to the scheduling/booking feature)
- Brief FAQ (3 questions) about onboarding and support
- Reassurance copy: response time, no hard sell, etc.
- Note: Once they submit, they may receive an automated follow-up via Conversation AI or a call from Voice AI — frame this as a benefit, not a surprise

---

## OUTPUT FORMAT

Return the full content as a single Markdown file using this structure:

```
# [WEBSITE_NAME] — Full Content & SEO Plan
## SEO Keyword Research Summary
## Page 1: Overview
## Page 2: Features
## Page 3: Use Cases
## Page 4: Resources
## Page 5: Pricing
## Page 6: About Us
## Page 7: Contact Us
```

Each page section must include the SEO block (keywords, meta title, meta description) before the copy.

Do not truncate. Write every page in full.

---

## HARD CONSTRAINTS — sanitize your output against these before delivering

- ❌ NO free trial language anywhere. No "Start free trial", "Try free", "14-day free", etc.
- ❌ NO fabricated statistics (specific percentages, revenue figures, time savings with exact numbers)
- ❌ NO named customer companies — testimonials use `FirstName LastInitial, City ST` format only
- ❌ NO social media links in page copy
- ❌ NO placeholder brackets in the deliverable (`[TODO]`, `[placeholder]`, etc.)
- ✅ Testimonial quotes are qualitative outcomes only ("we stopped losing weekend leads")
- ✅ CTAs: "Book a Demo", "Sign Up Now", "See Pricing", "Get Started"
