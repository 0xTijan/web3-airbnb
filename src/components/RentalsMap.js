import React, { useState, useEffect } from "react";
import { Map, Marker, GoogleApiWrapper } from "google-maps-react";


function RentalsMap({ locations, google, setHighLight }) {
  const [center, setCenter] = useState();

  // runs to center a map
  useEffect(() => {
    var arr = Object.keys(locations);
    
    // average let
    var getLat = (key) => locations[key]["lat"];
    var avgLat = arr.reduce((a, c) => a + Number(getLat(c)), 0) / arr.length;

    // average lng
    var getLng = (key) => locations[key]["lng"];
    var avgLng = arr.reduce((a, c) => a + Number(getLng(c)), 0) / arr.length;

    // we define the center of the map
    setCenter({ lat: avgLat, lng: avgLng });
  }, [locations]);

  return (
    <>
      {center && (
        <Map
          google={google}
          containerStyle={{
            width: "50vw",
            height: "calc(100vh - 135px)",
          }} 
          center={center}
          initialCenter={locations[0]}
          zoom={13}
          disableDefaultUI={true}
        >
          {locations.map((coords, i) => (
            <Marker position={coords} onClick={() => setHighLight(i)} />
          ))}
        </Map>
      )}
    </>
  );
}

export default GoogleApiWrapper({
  apiKey: "",
})(RentalsMap);
