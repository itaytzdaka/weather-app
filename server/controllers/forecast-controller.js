const express = require("express");
const router = express.Router();
const axios = require("axios");

//Get weather by city name
router.get("/:city", async (request, response) => {
    try {
        const city = request.params.city;
        const forecast = await axios.get(`http://api.weatherapi.com/v1/forecast.json?key=f1b31511aeac4bc4944132424221302&q=${city}&aqi=no&days=2`);
        const data = forecast.data;
        response.json(data);
    }
    catch (err) {
        response.status(500).send(err.message);
    }
});

module.exports = router;