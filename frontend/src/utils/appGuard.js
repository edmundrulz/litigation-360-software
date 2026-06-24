export function safeAsync(fn, fallback = null) {
  return async (...args) => {
    try {
      return await fn(...args);
    } catch (error) {
      console.error("🚨 SYSTEM ERROR CAUGHT:", error);
      return fallback;
    }
  };
}