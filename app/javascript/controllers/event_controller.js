import { Controller } from "@hotwired/stimulus"
//import { getUserPersonalityType, getMatchingTagsForPersonalityType } from "../../../config/personalities/personality_tags.yml";
import yaml from "js-yaml";
//import fs from "fs";
// Connects to data-controller="event"
export default class extends Controller {
  static targets = ["input"]
  token = null
  location = null
  matchingTags = [];

  connect() {
    this.getApiKey()
    this.loadMatchingTags();
  }

  loadMatchingTags() {
    fetch("/data/personality_tags.yml")
      .then((response) => response.text())
      .then((yamlData) => {
        const parsedData = yaml.load(yamlData);
        const personalityType = this.inputTarget.dataset.personalityType;
        const formattedPersonalityType = personalityType.replace(/_/g, '').toLowerCase(); // Remove underscores and convert to lowercase
        const matchingTags = Object.entries(parsedData.personality_types).reduce((tags, [key, value]) => {
          const formattedKey = key.replace(/_/g, ' ').toLowerCase(); // Remove underscores and convert key to lowercase
          if (formattedKey === formattedPersonalityType) {
            return value;
          }
          return tags;
        }, []);
        this.matchingTags = matchingTags.map((tag) => tag.replace(/_/g, '')); // Remove underscores from matching tags
      })
      .catch((error) => {
        console.error("Failed to load matching tags:", error);
      });
  }


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


  getApiKey() {
    const url = 'https://test.api.amadeus.com/v1/security/oauth2/token';
    const formData = new URLSearchParams();
    formData.append('grant_type', 'client_credentials');
    formData.append('client_id', 'KjTFTCnz0UdgVQ5vnr4GLTqhm7maB4BU');
    formData.append('client_secret', 'xO59KfcU9gmE50us');
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
    })
    .catch(error => {
      console.error(error);
    });
  }

   getRequest() {
    if (!this.token || !this.location) {
      return;
    }
    const { lat, lon } = this.location;
    const url = `https://test.api.amadeus.com/v1/reference-data/locations/pois?latitude=${lat}&longitude=${lon}&radius=1`;
    fetch(url, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${this.token}`,
      },
    })
    .then(response => response.json())
    .then((data) => {
      console.log("dataaa", data)
      // Check if data is an array
      if (Array.isArray(data.data)) {
        const filteredActivities = data.data.filter((activity) => {
          if (Array.isArray(activity.tags)) {
            return activity.tags.some((tag) => this.matchingTags.includes(tag));
          } else {
            return false;
          }
        });
        filteredActivities.forEach((activity) => {
          console.log(activity.name)
        })
      } else {
        console.error("Invalid data format. Expected an array.");
      }
    });
  }

  getDetailRequest() {
    if (!this.token || !this.location) {
      return;
    }
    const { lat, lon } = this.location;
    const url = `https://test.api.amadeus.com/v1/shopping/activities?latitude=${lat}&longitude=${lon}&radius=1`;
    fetch(url, {
      method: 'GET',
      headers: {
        "Authorization": `Bearer ${this.token}`,
      },
    })
    .then(response => response.json())
    .then((data) => {
      console.log("dataaa detail", data)
    });
  }

}



// get request for geocode


// `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(location)}&format=json`
