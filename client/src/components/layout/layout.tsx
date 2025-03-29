import React, { Component, ChangeEvent } from "react";
import "./layout.css";
import { ReactComponent as Logo } from "../../assets/svg/weather.svg";
import { ForecastModel } from "../../models/forecast-model";
import { getForecast } from "../../services/forecast";
import { getDate } from "../../services/date";
import { addZero } from "../../services/date";

interface LayoutState {
    forecast: ForecastModel;
    city: string;
    hoursToday: number[],
    hoursTomorrow: number[],
    error: string
}

export class Layout extends Component<any, LayoutState>{

    public constructor(props: any) {
        super(props);

        //get vacations from the store
        this.state = {
            forecast: {},
            city: "",
            hoursToday: [],
            hoursTomorrow: [],
            error: ""
        };

    }

    //get city name from text input
    private getCityInput = (args: ChangeEvent<HTMLInputElement>) => {
        const city = args.target.value;
        this.setState({ city });
    }

    //checking if user click on Enter
    private keyUp = (event) => {
        if (event.charCode === 13) {
            this.buttonGetData();
        }
    }

    //event handling -> user click on check button
    private buttonGetData = () => {
        //if city name is empty -> set error
        if (this.state.city == "") {
            const error="Enter name of city";
            this.setState({error});
        }

        //if exists prohibited characters -> set error
        else if (!this.validation(this.state.city)) {
            const error="City name is not valid";
            this.setState({error});
        }

        //if everything is ok get the data
        else {
            this.getForecastData(this.state.city)
        }
    }

    //validation of unprohibited characters 
    private validation = (city: string) => {
        const regex = /^[A-Za-z\'\-\s]+$/;
        return regex.test(city);
    }


    //get weather of city from server
    private getForecastData = async (city) => {
        try {
            let forecast = {};
            this.setState({ forecast })
            forecast = await getForecast(city);
            const error="";
            this.setState({ forecast ,error });
            this.getHours();
        } catch (error :any) {
            this.setState({error});
        }
    }

    //handle forecast for hours 
    private getHours = () => {

        const date = new Date();
        const hourNow = date.getHours();
        let hoursToday = [];
        let hoursTomorrow = [];

        switch (hourNow) {
            case 20:
                hoursToday = [20, 21, 22, 23];
                hoursTomorrow =[0];
                break;
            case 21:
                hoursToday = [21, 22, 23];
                hoursTomorrow =[0, 1];
                break;
            case 22:
                hoursToday = [22, 23];
                hoursTomorrow =[0, 1, 2];
                break;
            case 23:
                hoursToday = [23];
                hoursTomorrow =[0, 1, 2, 3];
                break;
            default:
                hoursToday = [hourNow, hourNow +1, hourNow +2, hourNow +3, hourNow +4];
                break;
        }

        this.setState({ hoursToday });
        this.setState({ hoursTomorrow });
    }


    public render() {
        return (
            <div className="layout">

                <section>
                    <main>
                        <header>
                            <Logo />
                        </header>
                        <p className="description">
                            Use our weather app <br />
                            to see the weather <br />
                            around the world
                        </p>
                        <div className="city-container">
                            <label className="city-label" htmlFor="city-input">City name</label>
                            <div className="city-box">
                                <input onChange={this.getCityInput} onKeyPress={this.keyUp} type="text" name="city-input" id="city-input" />
                                <button onClick={this.buttonGetData} >Check</button>
                            </div>
                            <span className="error">{this.state.error}</span>
                        </div>


                        {Object.keys(this.state.forecast).length > 0 && this.state.hoursToday.length > 0 &&
                            <div className="location">
                                <span>latitude {this.state.forecast.location.lat} &nbsp; longitude {this.state.forecast.location.lon}</span>
                                <span>accurate to {getDate(new Date(this.state.forecast.current.last_updated))}</span>
                            </div>
                        }
                    </main>

                    <aside>
                        {Object.keys(this.state.forecast).length > 0 &&

                            <div className="weather-container">
                                <div className="weather-container-2">
                                    <div className="weather">
                                        <h4 className="city-name">{this.state.forecast.location.name}</h4>
                                        <span className="country">{this.state.forecast.location.country}</span>
                                        <span className="date">{getDate(new Date(this.state.forecast.location.localtime))}</span>
                                        <span className="degree-value">{this.state.forecast.current.temp_c}<span className="degree">°</span></span>
                                        <span className="condition">{this.state.forecast.current.condition.text}</span>
                                        <div className="wrap-between">
                                            <div className="wrap-column">
                                                <span className="condition-title">precipitation</span>
                                                <span><b>{this.state.forecast.current.precip_mm} mm</b></span>
                                            </div>
                                            <div className="wrap-column">
                                                <span className="condition-title">humidity</span>
                                                <span><b>{this.state.forecast.current.humidity}%</b></span>
                                            </div>
                                            <div className="wrap-column">
                                                <span className="condition-title">wind</span>
                                                <span><b>{this.state.forecast.current.wind_kph} km/h</b></span>
                                            </div>
                                        </div>
                                        <div className="wrap-between">
                                            {this.state.hoursToday.length > 0 && this.state.hoursToday.map(h =>
                                                <div className="wrap-column" key={`forecast${h}`}>
                                                    <span className="weather-time">{addZero(h)}:00</span>
                                                    <span><b>{this.state.forecast.forecast.forecastday[0].hour[h].temp_c}°</b></span>
                                                </div>
                                            )}
                                            {this.state.hoursTomorrow.length > 0 && this.state.hoursTomorrow.map(h =>
                                                <div className="wrap-column" key={`forecast${h}`}>
                                                    <span className="weather-time">{addZero(h)}:00</span>
                                                    <span><b>{this.state.forecast.forecast.forecastday[1].hour[h].temp_c}°</b></span>
                                                </div>
                                            )}
                                        </div>
                                    </div>
                                </div>

                            </div>
                        }
                    </aside>
                </section>
                <footer>
                </footer>
            </div>
        );
    }
}
