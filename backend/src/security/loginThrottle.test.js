const { LoginThrottle } = require("./loginThrottle");

describe("login throttling", () => {
  test("locks an identity and network tuple at the governed threshold", () => {
    let now = 0;
    const throttle = new LoginThrottle({ maxFailures: 3, windowMs: 1000, lockMs: 5000, clock: () => now });
    expect(throttle.failure("USER@example.test", "127.0.0.1").blocked).toBe(false);
    expect(throttle.failure("user@example.test", "127.0.0.1").blocked).toBe(false);
    expect(throttle.failure("user@example.test", "127.0.0.1").blocked).toBe(true);
    now = 5001;
    expect(throttle.status("user@example.test", "127.0.0.1").blocked).toBe(false);
  });

  test("success clears prior failures", () => {
    const throttle = new LoginThrottle({ maxFailures: 2 });
    throttle.failure("user@example.test", "127.0.0.1");
    throttle.success("user@example.test", "127.0.0.1");
    expect(throttle.status("user@example.test", "127.0.0.1").blocked).toBe(false);
  });
});
