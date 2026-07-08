require("dotenv").config();

const express = require("express");
const cors = require("cors");
const path = require("path");

const authRoutes = require("./routes/auth");
const photosRoutes = require("./routes/photos");
const usersRoutes = require("./routes/users");

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.use("/uploads", express.static(path.join(__dirname, "..", "uploads")));

app.get("/", (req, res) => {
  res.json({ message: "Smilegram API" });
});

app.use("/api/auth", authRoutes);
app.use("/api/photos", photosRoutes);
app.use("/api/users", usersRoutes);

app.listen(PORT, () => {
  console.log(`Smilegram API lancee sur http://localhost:${PORT}`);
});