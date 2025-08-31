import ballerina/http;
import ballerina/io;

type Forecast record {
    string day;
    string condition;
    int temperature;
};

type Weather record {
    string city;
    string condition;
    int temperature;
    int humidity;
    int windSpeed;
    Forecast[] forecast;
};

final Weather[] weatherData = [
    {
        "city": "Colombo",
        "condition": "Sunny",
        "temperature": 32,
        "humidity": 65,
        "windSpeed": 18,
        "forecast": [
            {"day": "Mon", "condition": "Sunny", "temperature": 33},
            {"day": "Tue", "condition": "Cloudy", "temperature": 30},
            {"day": "Wed", "condition": "Rainy", "temperature": 28},
            {"day": "Thu", "condition": "Sunny", "temperature": 34},
            {"day": "Fri", "condition": "Windy", "temperature": 31}
        ]
    },
    {
        "city": "Kandy",
        "condition": "Cloudy",
        "temperature": 24,
        "humidity": 75,
        "windSpeed": 10,
        "forecast": [
            {"day": "Mon", "condition": "Cloudy", "temperature": 25},
            {"day": "Tue", "condition": "Sunny", "temperature": 27},
            {"day": "Wed", "condition": "Rainy", "temperature": 23},
            {"day": "Thu", "condition": "Cloudy", "temperature": 24},
            {"day": "Fri", "condition": "Sunny", "temperature": 26}
        ]
    },
    {
        "city": "Jaffna",
        "condition": "Rainy",
        "temperature": 28,
        "humidity": 82,
        "windSpeed": 22,
        "forecast": [
            {"day": "Mon", "condition": "Rainy", "temperature": 27},
            {"day": "Tue", "condition": "Rainy", "temperature": 28},
            {"day": "Wed", "condition": "Cloudy", "temperature": 29},
            {"day": "Thu", "condition": "Sunny", "temperature": 30},
            {"day": "Fri", "condition": "Cloudy", "temperature": 28}
        ]
    },
    {
        "city": "Galle",
        "condition": "Sunny",
        "temperature": 30,
        "humidity": 70,
        "windSpeed": 15,
        "forecast": [
            {"day": "Mon", "condition": "Sunny", "temperature": 31},
            {"day": "Tue", "condition": "Cloudy", "temperature": 29},
            {"day": "Wed", "condition": "Rainy", "temperature": 28},
            {"day": "Thu", "condition": "Sunny", "temperature": 32},
            {"day": "Fri", "condition": "Cloudy", "temperature": 30}
        ]
    },
    {
        "city": "Trincomalee",
        "condition": "Sunny",
        "temperature": 33,
        "humidity": 60,
        "windSpeed": 20,
        "forecast": [
            {"day": "Mon", "condition": "Sunny", "temperature": 34},
            {"day": "Tue", "condition": "Sunny", "temperature": 33},
            {"day": "Wed", "condition": "Cloudy", "temperature": 31},
            {"day": "Thu", "condition": "Rainy", "temperature": 30},
            {"day": "Fri", "condition": "Sunny", "temperature": 32}
        ]
    },
    {
        "city": "Batticaloa",
        "condition": "Cloudy",
        "temperature": 29,
        "humidity": 78,
        "windSpeed": 12,
        "forecast": [
            {"day": "Mon", "condition": "Cloudy", "temperature": 28},
            {"day": "Tue", "condition": "Rainy", "temperature": 27},
            {"day": "Wed", "condition": "Sunny", "temperature": 30},
            {"day": "Thu", "condition": "Cloudy", "temperature": 29},
            {"day": "Fri", "condition": "Rainy", "temperature": 28}
        ]
    },
    {
        "city": "Anuradhapura",
        "condition": "Sunny",
        "temperature": 31,
        "humidity": 62,
        "windSpeed": 14,
        "forecast": [
            {"day": "Mon", "condition": "Sunny", "temperature": 32},
            {"day": "Tue", "condition": "Cloudy", "temperature": 30},
            {"day": "Wed", "condition": "Sunny", "temperature": 31},
            {"day": "Thu", "condition": "Cloudy", "temperature": 29},
            {"day": "Fri", "condition": "Sunny", "temperature": 30}
        ]
    },
    {
        "city": "Ratnapura",
        "condition": "Rainy",
        "temperature": 26,
        "humidity": 85,
        "windSpeed": 8,
        "forecast": [
            {"day": "Mon", "condition": "Rainy", "temperature": 25},
            {"day": "Tue", "condition": "Cloudy", "temperature": 26},
            {"day": "Wed", "condition": "Rainy", "temperature": 24},
            {"day": "Thu", "condition": "Cloudy", "temperature": 25},
            {"day": "Fri", "condition": "Sunny", "temperature": 27}
        ]
    },
    {
        "city": "Badulla",
        "condition": "Cloudy",
        "temperature": 22,
        "humidity": 80,
        "windSpeed": 9,
        "forecast": [
            {"day": "Mon", "condition": "Cloudy", "temperature": 23},
            {"day": "Tue", "condition": "Rainy", "temperature": 22},
            {"day": "Wed", "condition": "Cloudy", "temperature": 21},
            {"day": "Thu", "condition": "Sunny", "temperature": 24},
            {"day": "Fri", "condition": "Cloudy", "temperature": 23}
        ]
    },
    {
        "city": "Matara",
        "condition": "Sunny",
        "temperature": 31,
        "humidity": 68,
        "windSpeed": 16,
        "forecast": [
            {"day": "Mon", "condition": "Sunny", "temperature": 32},
            {"day": "Tue", "condition": "Cloudy", "temperature": 30},
            {"day": "Wed", "condition": "Rainy", "temperature": 29},
            {"day": "Thu", "condition": "Sunny", "temperature": 31},
            {"day": "Fri", "condition": "Cloudy", "temperature": 30}
        ]
    }
];

service /weather on new http:Listener(8080) {

    resource function get .() returns http:Response|error {
        string htmlContent = check io:fileReadString("./weather_frontend.html");
        http:Response res = new;
        res.setHeader("Content-Type", "text/html");
        res.setTextPayload(htmlContent);
        return res;
    }

    resource function get all() returns Weather[] {
        return weatherData;
    }

    resource function get [string city]() returns Weather|http:NotFound {
        foreach Weather w in weatherData {
            if w.city.toLowerAscii() == city.toLowerAscii() {
                return w;
            }
        }
        return {body: "Weather data not found for " + city};
    }
}
