
export class ForecastModel {

    public constructor( 
        public location?: {
            name?: string,
            country?: string,
            lat?: number,
            lon?: number,
            localtime?: Date
        },
        public current?:{
            last_updated: Date,
            temp_c: number,
            condition?:{
                text: string
            },
            precip_mm?: number,
            humidity?: number,
            wind_kph?: number
        },
        public forecast?: {
            forecastday?:{
                0?:{
                    hour?:{
                        0?:{
                            temp_c: number
                        },
                        1?:{
                            temp_c: number
                        },
                        2?:{
                            temp_c: number
                        },
                        3?:{
                            temp_c: number
                        },
                        4?:{
                            temp_c: number
                        },
                        5?:{
                            temp_c: number
                        },
                        6?:{
                            temp_c: number
                        },
                        7?:{
                            temp_c: number
                        },
                        8?:{
                            temp_c: number
                        },
                        9?:{
                            temp_c: number
                        },
                        10?:{
                            temp_c: number
                        },
                        11?:{
                            temp_c: number
                        },
                        12?:{
                            temp_c: number
                        },
                        13?:{
                            temp_c: number
                        },
                        14?:{
                            temp_c: number
                        },
                        15?:{
                            temp_c: number
                        },
                        16?:{
                            temp_c: number
                        },
                        17?:{
                            temp_c: number
                        },
                        18?:{
                            temp_c: number
                        },
                        19?:{
                            temp_c: number
                        },
                        20?:{
                            temp_c: number
                        },
                        21?:{
                            temp_c: number
                        },
                        22?:{
                            temp_c: number
                        },
                        23?:{
                            temp_c: number
                        }
                    }
                },
                1?:{
                    hour?:{
                        0?:{
                            temp_c: number
                        },
                        1?:{
                            temp_c: number
                        },
                        2?:{
                            temp_c: number
                        },
                        3?:{
                            temp_c: number
                        },
                        4?:{
                            temp_c: number
                        },
                        5?:{
                            temp_c: number
                        },
                        6?:{
                            temp_c: number
                        },
                        7?:{
                            temp_c: number
                        },
                        8?:{
                            temp_c: number
                        },
                        9?:{
                            temp_c: number
                        },
                        10?:{
                            temp_c: number
                        },
                        11?:{
                            temp_c: number
                        },
                        12?:{
                            temp_c: number
                        },
                        13?:{
                            temp_c: number
                        },
                        14?:{
                            temp_c: number
                        },
                        15?:{
                            temp_c: number
                        },
                        16?:{
                            temp_c: number
                        },
                        17?:{
                            temp_c: number
                        },
                        18?:{
                            temp_c: number
                        },
                        19?:{
                            temp_c: number
                        },
                        20?:{
                            temp_c: number
                        },
                        21?:{
                            temp_c: number
                        },
                        22?:{
                            temp_c: number
                        },
                        23?:{
                            temp_c: number
                        }
                    }
                }
            }
        }
        ) {
    }
}