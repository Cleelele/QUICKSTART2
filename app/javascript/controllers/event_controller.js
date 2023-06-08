import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event"
export default class extends Controller {
  static targets = ["input"]
  token = null
  location = null

  connect() {
    console.log("You are connected!");
    this.getToken();
    this.getLocation();
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

  getAPIKey() {
    const url = 'https://test.api.amadeus.com/v1/security/oauth2/token';
    const formData = new URLSearchParams();
    formData.append('grant_type', 'client_credentials');
    formData.append('client_id', '{client_id}');
    formData.append('client_secret', '{client_secret}');
    console.log("Hana")
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: formData
  })
    .then(response => response.json())
    .then(data => {
      console.log(data);
    })
    .catch(error => {
      console.error(error);
    });
    }
  }


// get request for geocode


// `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(location)}&format=json`
