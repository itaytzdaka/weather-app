require('dotenv').config();  // Load environment variables

const express = require("express");
const server = express();

const cors = require("cors");

server.use(cors({
    origin: process.env.CORS_ORIGIN || "http://localhost:3001",
    credentials: true
}));



const forecastController=require("./controllers/forecast-controller");

server.use("/api/forecast", forecastController);


server.use(express.json());


// for monolith
const path = require("path");
server.use(express.static(path.join(__dirname, "./_front-end")));
server.use("*", (request, response) => {
    response.sendFile(path.join(__dirname, "./_front-end/index.html"));
});


const port=process.env.PORT || 3000;
server.listen(port, ()=>console.log("Listening on port " + port + " http://localhost:3000"));
