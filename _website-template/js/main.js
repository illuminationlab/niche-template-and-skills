/* ============================================
   IL CAMPBELL - Main JavaScript
   ============================================ */

document.addEventListener('DOMContentLoaded', () => {
  initNavigation();
  initScrollReveal();
  initCounterAnimations();
  initFAQ();
  initForms();
  initMarquee();
  initAnnouncementBar();
  initSVGAnimations();
});

/* ---------- Navigation ---------- */
function initNavigation() {
  const header = document.querySelector('.header');
  const mobileToggle = document.querySelector('.mobile-toggle');
  const mobileMenu = document.querySelector('.mobile-menu');

  // Mobile menu toggle
  if (mobileToggle && mobileMenu) {
    mobileToggle.addEventListener('click', () => {
      mobileToggle.classList.toggle('active');
      mobileMenu.classList.toggle('active');
      document.body.style.overflow = mobileMenu.classList.contains('active') ? 'hidden' : '';
    });

    // Mobile submenu toggles
    document.querySelectorAll('.mobile-nav-link[data-toggle]').forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        const submenu = link.nextElementSibling;
        if (submenu) {
          submenu.classList.toggle('active');
          link.querySelector('.chevron')?.classList.toggle('active');
        }
      });
    });
  }

  // Header + announcement bar are static now (they scroll away with the page),
  // so no scroll-based repositioning is needed. The old code here forced
  // position:absolute on the announcement bar past 50px scroll, which caused
  // overlap bugs. Removed.

  // Close mobile menu on link click
  document.querySelectorAll('.mobile-menu a:not([data-toggle])').forEach(link => {
    link.addEventListener('click', () => {
      mobileToggle?.classList.remove('active');
      mobileMenu?.classList.remove('active');
      document.body.style.overflow = '';
    });
  });

  // Close dropdowns when clicking outside
  document.addEventListener('click', (e) => {
    if (!e.target.closest('.nav-item')) {
      document.querySelectorAll('.dropdown').forEach(d => {
        d.style.opacity = '';
        d.style.visibility = '';
      });
    }
  });
}

/* ---------- Scroll Reveal ---------- */
function initScrollReveal() {
  const reveals = document.querySelectorAll('.reveal');
  if (!reveals.length) return;

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.1,
    rootMargin: '0px 0px -40px 0px'
  });

  reveals.forEach(el => observer.observe(el));
}

/* ---------- Counter Animations ---------- */
function initCounterAnimations() {
  const counters = document.querySelectorAll('[data-counter]');
  if (!counters.length) return;

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCounter(entry.target);
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });

  counters.forEach(el => observer.observe(el));
}

function animateCounter(el) {
  const target = parseFloat(el.dataset.counter);
  const duration = parseInt(el.dataset.duration) || 2000;
  const prefix = el.dataset.prefix || '';
  const suffix = el.dataset.suffix || '';
  const decimals = (target % 1 !== 0) ? 1 : 0;
  const start = performance.now();

  function update(now) {
    const elapsed = now - start;
    const progress = Math.min(elapsed / duration, 1);
    // Ease out cubic
    const ease = 1 - Math.pow(1 - progress, 3);
    const current = target * ease;

    el.textContent = prefix + current.toFixed(decimals).replace(/\B(?=(\d{3})+(?!\d))/g, ',') + suffix;

    if (progress < 1) {
      requestAnimationFrame(update);
    }
  }

  requestAnimationFrame(update);
}

/* ---------- FAQ Accordion ---------- */
function initFAQ() {
  document.querySelectorAll('.faq-question').forEach(btn => {
    btn.addEventListener('click', () => {
      const item = btn.parentElement;
      const answer = item.querySelector('.faq-answer');
      const isActive = item.classList.contains('active');

      // Close all other items
      item.closest('.faq-list')?.querySelectorAll('.faq-item.active').forEach(other => {
        if (other !== item) {
          other.classList.remove('active');
          other.querySelector('.faq-answer').style.maxHeight = '0';
        }
      });

      // Toggle current
      item.classList.toggle('active');
      if (!isActive) {
        answer.style.maxHeight = answer.scrollHeight + 'px';
      } else {
        answer.style.maxHeight = '0';
      }
    });
  });
}

/* ---------- Form Handling ---------- */
function initForms() {
  document.querySelectorAll('form[data-webhook]').forEach(form => {
    // Pre-populate data-autofill hidden fields on page load so they are set before any submit
    form.querySelectorAll('input[data-autofill]').forEach(input => {
      const kind = input.dataset.autofill;
      if (kind === 'page_url') input.value = window.location.href;
      else if (kind === 'referrer') input.value = document.referrer || '';
    });

    form.addEventListener('submit', async (e) => {
      e.preventDefault();

      const btn = form.querySelector('button[type="submit"]');
      const originalText = btn?.textContent;
      if (btn) {
        btn.disabled = true;
        btn.textContent = 'Sending...';
      }

      const formData = new FormData(form);
      const data = Object.fromEntries(formData);
      // Add submitted_at + parsed UTM params (read from current URL)
      data.submitted_at = new Date().toISOString();
      const urlParams = new URLSearchParams(window.location.search);
      ['utm_source','utm_medium','utm_campaign','utm_term','utm_content'].forEach(k => {
        const v = urlParams.get(k);
        if (v) data[k] = v;
      });
      // Inject source_site from window.SITE_CONFIG (set per-site in <head>).
      // The shared n8n workflow uses this to tag contacts by which niche site
      // the lead came from. form_location comes from a hidden input per-form.
      if (window.SITE_CONFIG && window.SITE_CONFIG.source_site) {
        data.source_site = window.SITE_CONFIG.source_site;
      }
      const webhook = form.dataset.webhook;

      try {
        // Use text/plain + no-cors mode to avoid a CORS preflight that n8n's webhook
        // endpoints do not answer. The request body is still JSON; n8n workflows should
        // JSON.parse the raw body. We cannot read the response in no-cors mode, so we
        // treat "fetch did not throw" as success. Fetch only throws on genuine network
        // errors (DNS failure, offline, connection refused).
        await fetch(webhook, {
          method: 'POST',
          mode: 'no-cors',
          headers: { 'Content-Type': 'text/plain;charset=UTF-8' },
          body: JSON.stringify(data),
        });
        // Fire a cancelable event so pages can hook in for custom behavior
        // (intent-based redirects, prefill handoff, etc.). If a listener calls
        // e.preventDefault(), we skip the default success message + reset -- the
        // page is taking over the post-submit flow.
        const successEvent = new CustomEvent('form:success', {
          detail: { data, formElement: form },
          cancelable: true,
          bubbles: true
        });
        const pageWillHandle = !form.dispatchEvent(successEvent);
        if (!pageWillHandle) {
          showFormMessage(form, 'success', 'Thank you! We\'ll be in touch shortly.');
          form.reset();
        }
      } catch (err) {
        showFormMessage(form, 'error', 'Something went wrong. Please try again or call us directly.');
      } finally {
        if (btn) {
          btn.disabled = false;
          btn.textContent = originalText;
        }
      }
    });
  });
}

function showFormMessage(form, type, message) {
  let msgEl = form.querySelector('.form-message');
  if (!msgEl) {
    msgEl = document.createElement('div');
    msgEl.className = 'form-message';
    form.appendChild(msgEl);
  }

  msgEl.className = `form-message form-message--${type}`;
  msgEl.textContent = message;
  msgEl.style.padding = '12px 16px';
  msgEl.style.borderRadius = '8px';
  msgEl.style.marginTop = '16px';
  msgEl.style.fontSize = '0.9375rem';
  msgEl.style.fontWeight = '500';

  if (type === 'success') {
    msgEl.style.background = 'rgba(76, 175, 80, 0.1)';
    msgEl.style.color = '#4CAF50';
    msgEl.style.border = '1px solid rgba(76, 175, 80, 0.2)';
  } else {
    msgEl.style.background = 'rgba(255, 82, 82, 0.1)';
    msgEl.style.color = '#FF5252';
    msgEl.style.border = '1px solid rgba(255, 82, 82, 0.2)';
  }

  setTimeout(() => msgEl.remove(), 5000);
}

/* ---------- Marquee ---------- */
function initMarquee() {
  document.querySelectorAll('.marquee-inner').forEach(inner => {
    // Clone content for seamless loop
    const clone = inner.innerHTML;
    inner.innerHTML += clone;
  });
}

/* ---------- Announcement Bar ---------- */
function initAnnouncementBar() {
  const closeBtn = document.querySelector('.announcement-close');
  const bar = document.querySelector('.announcement-bar');
  if (closeBtn && bar) {
    closeBtn.addEventListener('click', () => {
      bar.style.display = 'none';
      document.querySelector('.header').style.top = '0';
    });
  }
}

/* ---------- SVG Line Animations ---------- */
function initSVGAnimations() {
  const svgElements = document.querySelectorAll('.hero-svg-decoration');
  if (!svgElements.length) return;

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.querySelectorAll('.line').forEach((line, i) => {
          setTimeout(() => line.classList.add('animated'), i * 200);
        });
        entry.target.querySelectorAll('.dot-pulse').forEach((dot, i) => {
          setTimeout(() => dot.classList.add('animated'), 1000 + i * 150);
        });
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.2 });

  svgElements.forEach(el => observer.observe(el));
}

/* ---------- Smooth Scroll for Anchor Links ---------- */
document.addEventListener('click', (e) => {
  const link = e.target.closest('a[href^="#"]');
  if (link) {
    const target = document.querySelector(link.getAttribute('href'));
    if (target) {
      e.preventDefault();
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }
});

/* ---------- Utility: Throttle ---------- */
function throttle(fn, wait) {
  let last = 0;
  return function (...args) {
    const now = Date.now();
    if (now - last >= wait) {
      last = now;
      fn.apply(this, args);
    }
  };
}
