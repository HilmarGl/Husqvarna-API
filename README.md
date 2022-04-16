# Husqvarna-API
A Bash Script working with the new Husqvarna API
It fetch the important value STATE and ERRORCODE and merge them to ONE value and write it to a influxDB for using with Grafana.
The Access token revokes after ~24hr - Don´t know why. So I recreate one on every hit.
Only the important Errorcodes are in here at the moment
