import { Controller } from "@hotwired/stimulus"
import { getUserPersonalityType, getMatchingTagsForPersonalityType } from "./personality"

// Connects to data-controller="event"
export default class extends Controller {
  static targets = ["input"]
  token = null
  location = null

  connect() {
    console.log("im connected!!")
    this.getApiKey()
  }
  // get location & convert to lat and long

  getLocation() {
    const location = this.inputTarget.value // assign attribute
    const urlAddress = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(location)}&format=json`
    console.log("geocolating.......")
    fetch (urlAddress)
      .then(response => response.json())
      .then(data => {
        const { lat, lon } = data[0]
        this.location = { lat, lon }
        console.log("i got the geolocation")
        console.log(this.location)
        this.getRequest()
      })
  }

  // post req to get the token and update it

  getApiKey() {
    const url = 'https://test.api.amadeus.com/v1/security/oauth2/token';
    const formData = new URLSearchParams();
    formData.append('grant_type', 'client_credentials');
    formData.append('client_id', 'KjTFTCnz0UdgVQ5vnr4GLTqhm7maB4BU');
    formData.append('client_secret', 'xO59KfcU9gmE50us');
    console.log("fetching api key")
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: formData //body: body.toString()
    })
    .then(response => response.json())
    .then(data => {
      this.token = data.access_token;
      console.log("i got the api key")
      console.log(this.token)
      if (this.location) {
        this.getRequest();
      }
      //console.log(this.token)
    })
    .catch(error => {
      console.error(error);
    });
  }

  getUserPersonalityType() {
    return this.inputTarget.dataset.personalityType;
  }

   // get request to receive activities from api

   getRequest() {
    if (!this.token || !this.location) {
      return;
    }
    //console.log("fetching activities!!")
    //console.log(this.location)
    const { lat, lon } = this.location;
    const url = `https://test.api.amadeus.com/v1/reference-data/locations/pois?latitude=41.397158&longitude=2.160873&radius=1`;

    fetch(url, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${this.token}`,
      },
    })
    .then(response => response.json())
    .then((data) => {
      console.log("activities fetched!!!!")
      console.log(data)

      const personalityType = this.getUserPersonalityType();
      console.log(this.personalityType)
      const matchingTags = getMatchingTagsForPersonalityType(personalityType);

      // Check if data is an array
      if (Array.isArray(data.data)) {
        const filteredActivities = data.data.filter(activity => {
          if (Array.isArray(activity.tags)) {
            return activity.tags.some(tag => matchingTags.includes(tag));
          } else {
            return false; // Skip activities without tags
          }
        });

    console.log("filtered activities:");
    console.log(filteredActivities);

  } else {
    console.error("Invalid data format. Expected an array.");
  }

    // Use the filtered activities as needed in your application
    });
  }
}



// get request for geocode


// `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(location)}&format=json`
