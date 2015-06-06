for VAR in {1..255}
  # Addresses only go up to 224...
do 
  echo "$VAR.0.0.0"
  geoiplookup $VAR.0.0.0
done
