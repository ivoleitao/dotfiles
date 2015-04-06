#!/bin/bash

source "$(dirname $0)/config.sh"

format_weather() {
    local value=""
	local condition=""
    local sunriseTime=""
    local sunsetTime=""
    if [[ -n $1 ]]; then
        IFS=$WEATHER_DATA_SEPARATOR read -ra weatherData <<< "$1"
        if [ "${#weatherData[@]}" -eq "4" ]; then
            value="${weatherData[0]}"
	        condition="${weatherData[1]}"
            sunriseTime="${weatherData[2]}"
            sunsetTime="${weatherData[3]}"
        fi
    fi
    
    if [[ -n $value && -n $condition && -n $sunriseTime && -n $sunsetTime ]]; then
        local icon="?"
        case "$condition" in
            "sunny" | "hot")
                hourmin=$(date +%H%M)
                if [ "$hourmin" -ge "$sunsetTime" -o "$hourmin" -le "$sunriseTime" ]; then
                    icon=$WEATHER_ICON_HOT_NIGHT
                else
                    icon=$WEATHER_ICON_HOT_DAY
                fi
                ;;
            "rain" | "mixed rain and snow" | "mixed rain and sleet" | "freezing drizzle" | "drizzle" | "light drizzle" | "freezing rain" | "showers" | "mixed rain and hail" | "scattered showers" | "isolated thundershowers" | "thundershowers" | "light rain with thunder" | "light rain" |"light rain shower" | "rain and snow")
                icon=$WEATHER_ICON_RAIN
                ;;
            "snow" | "mixed snow and sleet" | "snow flurries" | "light snow showers" | "blowing snow" | "sleet" | "hail" | "heavy snow" | "scattered snow showers" | "snow showers" | "light snow" | "snow/windy" | "snow grains" | "snow/fog")
                icon=$WEATHER_ICON_SNOW
                ;;
            "cloudy" | "mostly cloudy" | "partly cloudy" | "partly cloudy/windy")
                icon=$WEATHER_ICON_CLOUDY
                ;;
            "tornado" | "tropical storm" | "hurricane" | "severe thunderstorms" | "thunderstorms" | "isolated thunderstorms" | "scattered thunderstorms")
                icon=$WEATHER_ICON_STORM
                ;;
            "dust" | "foggy" | "fog" | "haze" | "smoky" | "blustery" | "mist")
                icon=$WEATHER_ICON_FOGGY
                ;;
            "windy" | "fair/windy")
                icon=$WEATHER_ICON_WINDY
                ;;
            "clear" | "fair" | "cold")
                hourmin=$(date +%H%M)
                if [ "$hourmin" -ge "$sunsetTime" -o "$hourmin" -le "$sunriseTime" ]; then
                    icon=$WEATHER_ICON_COLD_NIGHT
                else
                    icon=$WEATHER_ICON_COLD_DAY
                fi
                ;;
        esac

        echo "<span foreground='$WEATHER_ICON_COLOR'>$icon</span> $value°"
    else
        echo ""
    fi
}

panel_weather() {
    local value=""
    local weather_data=$(curl --max-time 4 -s "$WEATHER_URL")
    if [ "$?" -eq "0" ]; then
        # Pull the times for sunrise and sunset so we know when to change the day/night indicator
        # <yweather:astronomy sunrise="6:56 am" sunset="6:21 pm"/>
        local sunriseTime=$(date -d"$(echo "$weather_data" | grep "yweather:astronomy" | sed 's/^\(.*\)sunset.*/\1/' | sed 's/^.*sunrise="\(.*m\)".*/\1/')" +%H%M)
        local sunsetTime=$(date -d"$(echo "$weather_data" | grep "yweather:astronomy" | sed 's/^.*sunset="\(.*m\)".*/\1/')" +%H%M)
        # <yweather:condition  text="Clear"  code="31"  temp="66"  date="Mon, 01 Oct 2012 8:00 pm CST" />
        local conditionSection=$(echo "$weather_data" | grep -PZo "<yweather:condition [^<>]*/>")
        local degree=$(echo "$conditionSection" | sed 's/.*temp="\([^"]*\)".*/\1/')
        local condition=$(echo "$conditionSection" | sed 's/.*text="\([^"]*\)".*/\1/' | tr '[:upper:]' '[:lower:]')

        local sunrise=$sunriseTime
        local sunset=$sunsetTime
        local deg=$degree
        local cond=$condition

        if [[ -n "$degree" && -n "$condition" ]]; then
            if [ "$WEATHER_UNIT" == "k" ]; then
                degree=$(echo "${degree} + 273.15" | bc)
            fi
            value="$degree$WEATHER_DATA_SEPARATOR$condition$WEATHER_DATA_SEPARATOR$sunriseTime$WEATHER_DATA_SEPARATOR$sunsetTime"
        fi
    fi

    echo "$(format_weather "$value")"
}

echo $(panel_weather)
