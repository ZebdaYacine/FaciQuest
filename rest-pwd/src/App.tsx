import { useState } from "react";
import "./App.css";

export default function App() {
  const [newpassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [message, setMessage] = useState("");
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e: { preventDefault: () => void }) => {
    e.preventDefault();

    if (newpassword !== confirmPassword) {
      setMessage("Passwords do not match");
      setSuccess(false);
      return;
    }

    try {
      const response = await fetch(
        "http://185.209.230.104:3000/profile/set-new-pwd",
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ newpassword: newpassword }),
        }
      );

      const data = await response.json();

      if (response.ok) {
        setMessage("Password reset successful!");
        setSuccess(true);
        setNewPassword("");
        setConfirmPassword("");
      } else {
        setMessage(data.error || "Failed to reset password");
        setSuccess(false);
      }
    } catch (err) {
      if (err instanceof Error) {
        setMessage("Error: " + err.message);
      } else {
        setMessage("An unknown error occurred");
      }
      setSuccess(false);
    }
  };

  return (
    <div className="container">
      <div className="card">
        <h2 className="title">Reset Password</h2>
        <form onSubmit={handleSubmit} className="form">
          <input
            type="password"
            placeholder="New Password"
            value={newpassword}
            onChange={(e) => setNewPassword(e.target.value)}
            required
            className="input"
          />
          <input
            type="password"
            placeholder="Confirm Password"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            required
            className="input"
          />
          <button type="submit" className="button">
            Reset Password
          </button>
        </form>
        {message && (
          <p className={`message ${success ? "success" : "error"}`}>
            {message}
          </p>
        )}
      </div>
    </div>
  );
}
