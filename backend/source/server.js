require("dotenv").config();

const express = require("express");
const cors = require("cors");
const path = require("path");

const authRoutes = require("./routes/auth");
const photosRoutes = require("./routes/photos");
const usersRoutes = require("./routes/users");