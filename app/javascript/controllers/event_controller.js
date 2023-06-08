import { Controller } from "@hotwired/stimulus"

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
    fetch (urlAddress)
      .then(response => response.json())
      .then(data => {
        const { lat, lon } = data[0]
        this.location = { lat, lon }
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
    console.log("im getting the token!")
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
      if (this.location) {
        this.getRequest();
      }
      //console.log(this.token)
    })
    .catch(error => {
      console.error(error);
    });
  }

   // get request to receive activities from api

   getRequest() {
    if (!this.token || !this.location) {
      return;
    }
    console.log("im already on the api request")
    console.log(this.location)
    const { lat, lon } = this.location;
    const url = `https://test.api.amadeus.com/v1/reference-data/locations/pois?latitude=${lat}&longitude=${lon}`;
    fetch(url, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${this.token}`,
      }
    })
    .then(response => response.json())
    .then((data) => {
      console.log(data)
    })
   }
  }


// get request for geocode


// `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(location)}&format=json`
