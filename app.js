const express = require("express");
const app = express();
const helpers = require("./helpers");
const jwt = require("jwt-then");
const upload = require("express-fileupload");

app.engine("hbs", require("exphbs"));
app.set("view engine", "hbs");

require("dotenv").config({ path: "./VARIABLES.env" });

app.use(express.static("public"));
app.use(upload());

const session = require("express-session");
app.use(
  session({
    cookie: { maxAge: 1000 },
    secret: process.env.SECRET,
    resave: false,
    saveUninitialized: false
  })
);

const cookieParser = require("cookie-parser");
app.use(cookieParser());

app.use(require("flash")());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use((req, res, next) => {
  console.log(req.sessionID + "\n\n");
  let token = req.cookies.token || "";
  res.locals.h = helpers;
  res.locals.url = req.originalUrl;

  jwt
    .verify(token, process.env.SECRET)
    .then(payload => {
      req.userData = payload;
      if (payload.type === "admin") {
        res.locals.admin = true;
      } else if (payload.type === "seller") {
        res.locals.seller = true;
      }
      res.locals.myID = payload.id;
      next();
    })
    .catch(err => {
      res.locals.admin = false;
      res.locals.seller = false;
      next();
    });
});

app.use("/", require("./routes/index"));
app.use("/", require("./routes/seller"));
app.use("/", require("./routes/admin"));

module.exports = app;
