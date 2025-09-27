import { useState, useEffect } from "react";
import "./App.css";

export default function ResetPassword() {
  const [pin, setPin] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [token, setToken] = useState<string | null>(null);
  const [message, setMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  // ✅ Extract token from URL query params
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const t = params.get("token");
    const pin = params.get("pin");
    if (t) setToken(t);
    if (pin) setPin(pin);
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMessage("");

    if (newPassword !== confirmPassword) {
      setMessage("Passwords do not match");
      return;
    }

    setIsLoading(true);

    try {
      const response = await fetch(
        "http://185.209.230.104:3000/profile/set-new-pwd",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: JSON.stringify({
            pin,
            newPassword,
          }),
        }
      );

      const data = await response.json();
      if (response.ok) {
        setMessage("Password reset successful!");
      } else {
        setMessage(data.error || "Failed to reset password");
      }
    } catch (err: unknown) {
      if (err instanceof Error) {
        setMessage("Error: " + err.message);
      } else {
        setMessage("An unknown error occurred");
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="container">
      <div className="card">
        <h2 className="title">Reset Password</h2>
        <form onSubmit={handleSubmit} className="form">
          <div className="input-group">
            <input
              type="password"
              placeholder="New Password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              required
              className="input "
            />
            <span className="input-icon">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
              </svg>
            </span>
          </div>

          <div className="input-group">
            <input
              type="password"
              placeholder="Confirm Password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
              className="input"
            />
            <span className="input-icon">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
              </svg>
            </span>
          </div>

          <button type="submit" className="button" disabled={isLoading}>
            {isLoading ? <div className="spinner"></div> : "Reset Password"}
          </button>
        </form>

        {message && (
          <p
            className={`message ${
              message.includes("successful") ? "success" : "error"
            }`}
          >
            {message}
          </p>
        )}
      </div>
    </div>
  );
}
