const express = require("express");
const app = express();
const bodyParser = require("body-parser");

const uzmanlikAlaniRouter = require("./routes/uzmanlikAlaniRoute");
const mesajRouter = require("./routes/mesajRoute");
const doktorUzmanlikAlaniRouter = require("./routes/doktorUzmanlikAlaniRoute");
const anabilimDaliRoute = require("./routes/anabilimDaliRoute");
const hastaRoute = require("./routes/hastaRoute");
const doktorRoute = require("./routes/doktorRoute");

app.use(bodyParser.json());

app.get("/", (req, res) => {
    res.send("Welcome Healmob API")
})

app.use('/uzmanlikalani', uzmanlikAlaniRouter);
app.use('/mesaj', mesajRouter);
app.use('/doktoruzmanlikalani', doktorUzmanlikAlaniRouter);
app.use('/anabilimdali', anabilimDaliRoute);
app.use('/hasta', hastaRoute);
app.use('/doktor', doktorRoute);

app.listen(3000, function () {
    console.log('Server running(localhost:3000)');
});