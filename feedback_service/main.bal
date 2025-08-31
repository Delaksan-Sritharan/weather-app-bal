import ballerina/http;
import ballerina/io;

// ==========================
// Weather Data (local array)
// ==========================
type Weather record {
    string city;
    string condition;
    int temperature; // in Celsius
};

final Weather[] weatherData = [
    {city: "Colombo", condition: "Sunny", temperature: 32},
    {city: "Kandy", condition: "Cloudy", temperature: 24},
    {city: "Jaffna", condition: "Rainy", temperature: 28},
    {city: "Galle", condition: "Windy", temperature: 30},
    {city: "Trincomalee", condition: "Hot", temperature: 34}
];

// ==========================
// HTTP Service
// ==========================
service /weather on new http:Listener(8080) {

    // Serve HTML frontend
    resource function get .() returns http:Response|error {
        string htmlContent = check io:fileReadString("./weather_frontend.html");
        http:Response res = new;
        res.setHeader("Content-Type", "text/html");
        res.setTextPayload(htmlContent);
        return res;
    }

    // Get all weather data
    resource function get all() returns Weather[] {
        return weatherData;
    }

    // Get weather for a specific city
    resource function get [string city]() returns Weather|http:NotFound {
        foreach Weather w in weatherData {
            if w.city.toLowerAscii() == city.toLowerAscii() {
                return w;
            }
        }
        return {body: "Weather data not found for " + city};
    }
}
