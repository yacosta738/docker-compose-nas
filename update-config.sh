#!/bin/bash

# See https://stackoverflow.com/a/44864004 for the sed GNU/BSD compatible hack

echo "Updating Radarr configuration..."
until [ -f ./radarr/config.xml ]
do
  sleep 5
done
sed -i.bak "s/<UrlBase><\/UrlBase>/<UrlBase>\/radarr<\/UrlBase>/" ./radarr/config.xml && rm ./radarr/config.xml.bak

# Extract the API key from the Radarr configuration file
radarr_api_key=$(sed -n 's/.*<ApiKey>\(.*\)<\/ApiKey>.*/\1/p' ./radarr/config.xml)

sed -i.bak 's/^RADARR_API_KEY=.*/RADARR_API_KEY='$radarr_api_key'/' .env && rm .env.bak

echo "Updating Sonarr configuration..."
until [ -f ./sonarr/config.xml ]
do
  sleep 5
done
sed -i.bak "s/<UrlBase><\/UrlBase>/<UrlBase>\/sonarr<\/UrlBase>/" ./sonarr/config.xml && rm ./sonarr/config.xml.bak

# Extract the API key from the Sonarr configuration file
sonarr_api_key=$(sed -n 's/.*<ApiKey>\(.*\)<\/ApiKey>.*/\1/p' ./sonarr/config.xml)

sed -i.bak 's/^SONARR_API_KEY=.*/SONARR_API_KEY='$sonarr_api_key'/' .env && rm .env.bak

echo "Updating Prowlarr configuration..."
until [ -f ./prowlarr/config.xml ]
do
  sleep 5
done
sed -i.bak "s/<UrlBase><\/UrlBase>/<UrlBase>\/prowlarr<\/UrlBase>/" ./prowlarr/config.xml && rm ./prowlarr/config.xml.bak

# Extract the API key from the Prowlarr configuration file
prowlarr_api_key=$(sed -n 's/.*<ApiKey>\(.*\)<\/ApiKey>.*/\1/p' ./prowlarr/config.xml)

sed -i.bak 's/^PROWLARR_API_KEY=.*/PROWLARR_API_KEY='$prowlarr_api_key'/' .env && rm .env.bak

echo "Updating Bazarr configuration..."
until [ -f ./bazarr/config/config.ini ]
do
  sleep 5
done

# Modify the base_url parameter in config.ini
sed -i.bak '/^\[general\]/,/^\[/s/^base_url =.*/base_url = \/bazarr/' ./bazarr/config/config.ini && rm ./bazarr/config/config.ini.bak
sed -i.bak '/^\[sonarr\]/,/^\[/s/^base_url =.*/base_url = \/sonarr/' ./bazarr/config/config.ini && rm ./bazarr/config/config.ini.bak
sed -i.bak '/^\[radarr\]/,/^\[/s/^base_url =.*/base_url = \/radarr/' ./bazarr/config/config.ini && rm ./bazarr/config/config.ini.bak
# Modify the apikey parameter in config.ini
sed -i.bak '/^\[sonarr\]/,/^\[/s/^apikey =.*/apikey = '"$sonarr_api_key"'/' ./bazarr/config/config.ini && rm ./bazarr/config/config.ini.bak
sed -i.bak '/^\[radarr\]/,/^\[/s/^apikey =.*/apikey = '"$radarr_api_key"'/' ./bazarr/config/config.ini && rm ./bazarr/config/config.ini.bak
# Modify the ip parameter in config.ini
sed -i.bak '/^\[sonarr\]/,/^\[/s/^ip =.*/ip = sonarr/' ./bazarr/config/config.ini && rm ./bazarr/config/config.ini.bak
sed -i.bak '/^\[radarr\]/,/^\[/s/^ip =.*/ip = radarr/' ./bazarr/config/config.ini && rm ./bazarr/config/config.ini.bak


# Extract the API key from the Bazarr configuration file
bazarr_api_key=$(sed -n 's/.*apikey = \(.*\)/\1/p' ./bazarr/config/config.ini)

# Update the API key in the .env file
sed -i.bak "s/^BAZARR_API_KEY=.*/BAZARR_API_KEY=$bazarr_api_key/" .env && rm .env.bak


echo "Updating Jellyfin configuration..."
until [ -f ./jellyfin/network.xml ]
do
  sleep 5
done
sed -i.bak "s/<BaseUrl \/>/<BaseUrl>\/jellyfin<\/BaseUrl>/" ./jellyfin/network.xml && rm ./jellyfin/network.xml.bak

echo "Restarting containers..."
docker compose restart radarr sonarr prowlarr jellyfin
