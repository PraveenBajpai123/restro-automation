// Browsers block audio until the first tap. Call unlockSound() from a click handler once.
const cache = {};
let unlocked = false;

export function unlockSound() {
  if (unlocked) return;
  unlocked = true;
  for (const name of ['customer', 'staff']) {
    const a = new Audio(`/${name}.mp3`);
    a.muted = true;
    a.play().then(() => { a.pause(); a.currentTime = 0; a.muted = false; }).catch(() => { a.muted = false; });
    cache[name] = a;
  }
}

export function playSound(name) {
  try {
    const a = cache[name] || new Audio(`/${name}.mp3`);
    a.currentTime = 0;
    a.play().catch(() => {});
  } catch {
    /* audio is best-effort */
  }
}
