document.addEventListener("DOMContentLoaded", function () {

  // TOGGLE BOTTONI ENTITÀ
  const buttons = document.querySelectorAll(".entity-btn");
  const container = document.getElementById("elenchi-entita");

  buttons.forEach(btn => {
    btn.addEventListener("click", function () {
      const type = this.dataset.type;
      const groups = container.querySelectorAll(".entity-group");

      const currentlyVisible = [...groups].some(g => g.classList.contains(type) && g.style.display !== "none");
      if (currentlyVisible) {
        // second click on same type => hide all
        container.style.display = "none";
        groups.forEach(g => g.style.display = "none");
        return;
      }

      container.style.display = "block";
      groups.forEach(g => {
        if (g.classList.contains(type)) {
          g.style.display = "block";
        } else {
          g.style.display = "none";
        }
      });
    });
  });

  // TOGGLE CHOICE (orig/reg + abbr/expan)
  document.querySelectorAll(".choice-wrapper").forEach(wrapper => {

    const orig = wrapper.querySelector(".orig");
    const reg = wrapper.querySelector(".reg");

    const abbr = wrapper.querySelector(".abbr");
    const expan = wrapper.querySelector(".expan");

    // Stato iniziale
    if (orig && reg) {
      reg.style.display = "none";
      wrapper.style.cursor = "pointer";
    }

    if (abbr && expan) {
      expan.style.display = "none";
      wrapper.style.cursor = "pointer";
    }

    wrapper.addEventListener("click", function () {

      // ORIG / REG
      if (orig && reg) {
        if (orig.style.display !== "none") {
          orig.style.display = "none";
          reg.style.display = "inline";
        } else {
          orig.style.display = "inline";
          reg.style.display = "none";
        }
      }

      // ABBR / EXPAN
      if (abbr && expan) {
        if (abbr.style.display !== "none") {
          abbr.style.display = "none";
          expan.style.display = "inline";
        } else {
          abbr.style.display = "inline";
          expan.style.display = "none";
        }
      }

    });

  });

  // CLICK SU VOCE ELENCO
  document.querySelectorAll(".entity-link").forEach(link => {
    link.addEventListener("click", function (e) {
      e.preventDefault();
      const ref = this.dataset.ref;

      const target = document.querySelector(`[data-ref="${ref}"]`);
      if (!target) return;

      const a = target.tagName.toLowerCase() === "a" ? target : target.querySelector("a");

      if (a && a.href && a.getAttribute("href") !== "#") {
        window.open(a.href, "_blank");
        return;
      }

      target.scrollIntoView({behavior:"smooth", block:"center"});
      target.classList.add("hl-entity");
      setTimeout(()=>target.classList.remove("hl-entity"),2000);
    });
  });

  // CLICK ZONE FACSIMILE
  document.querySelectorAll(".zone-overlay").forEach(zone => {
    zone.addEventListener("click", function () {
      const id = this.dataset.corresp;
      evidenziaParagrafo(id);
      const p = document.getElementById(id);
      if (p) p.scrollIntoView({behavior:"smooth", block:"center"});
    });
  });

});


// FUNZIONE PARAGRAFO + FACSIMILE
function evidenziaParagrafo(id) {

  document.querySelectorAll(".paragrafo, .nota-testo").forEach(p => p.classList.remove("active"));
  document.querySelectorAll(".zone-overlay").forEach(z => z.classList.remove("active"));
  document.querySelectorAll("[data-ref]").forEach(e => e.classList.remove("hl-entity"));

  const p = document.getElementById(id);
  if (p) p.classList.add("active");

  document.querySelectorAll(`.nota-testo[id="${id}"]`).forEach(n => n.classList.add("active"));

  document.querySelectorAll(`.zone-overlay[data-corresp="${id}"]`).forEach(z => z.classList.add("active"));

  if (p) {
    p.querySelectorAll("[data-ref]").forEach(e => e.classList.add("hl-entity"));
  }

  document.querySelectorAll(`.nota-testo[id="${id}"] [data-ref]`).forEach(e => e.classList.add("hl-entity"));
}

window.evidenziaParagrafo = evidenziaParagrafo;
