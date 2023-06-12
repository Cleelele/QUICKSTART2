import { Controller } from "@hotwired/stimulus";
import yaml from "js-yaml";

export default class extends Controller {
  static targets = ["input"];
  token = null;
  location = null;
  matchingTags = [];
  filteredActivities = [];

  connect() {
    this.getApiKey();
    this.loadMatchingTags();
  }

  loadMatchingTags() {
    fetch("/data/personality_tags.yml")
      .then((response) => response.text())
      .then((yamlData) => {
        const parsedData = yaml.load(yamlData);
        const personalityType = this.inputTarget.dataset.personalityType;
        const formattedPersonalityType = personalityType.replace(/_/g, '').toLowerCase();
        const matchingTags = Object.entries(parsedData.personality_types).reduce((tags, [key, value]) => {
          const formattedKey = key.replace(/_/g, ' ').toLowerCase();
          if (formattedKey === formattedPersonalityType) {
            return value;
          }
          return tags;
        }, []);
        this.matchingTags = matchingTags.map((tag) => tag.replace(/_/g, ''));
      })
      .catch((error) => {
        console.error("Failed to load matching tags:", error);
      });
  }

  getLocation() {
    const location = this.inputTarget.value;
    const urlAddress = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(location)}&format=json`;
    fetch(urlAddress)
      .then(response => response.json())
      .then(data => {
        const { lat, lon } = data[0];
        this.location = { lat, lon };
        this.getRequest();
        this.getDetailRequest();
      });
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
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      this.token = data.access_token;
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
      console.log("dataaa", data);
      if (Array.isArray(data.data)) {
        this.filteredActivities = data.data.filter((activity) => {
          if (Array.isArray(activity.tags)) {
            return activity.tags.some((tag) => this.matchingTags.includes(tag));
          } else {
            return false;
          }
        });
        console.log("Filtered Activities:", this.filteredActivities);
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
        console.log("dataaa detail", data);
        if (Array.isArray(data.data)) {
          const detailedActivities = data.data || [];
          const matchingActivities = [];

          this.filteredActivities.forEach((filteredActivity) => {
            const filteredActivityName = filteredActivity.name.toLowerCase();

            const activitiesMatchingName = detailedActivities.filter((detailedActivity) => {
              const detailedActivityName = detailedActivity.name.toLowerCase();
              const detailedActivityDescription = detailedActivity.description ? detailedActivity.description.toLowerCase() : '';

              return (
                detailedActivityName.includes(filteredActivityName) ||
                detailedActivityDescription.includes(filteredActivityName)
              );
            });

            if (activitiesMatchingName.length > 0) {
              matchingActivities.push(...activitiesMatchingName);
            }
          });

          // Find the UL element by its id
          const ul = document.getElementById('activity-cards');

          // Display information for the matching activities
          matchingActivities.forEach((matchingActivity) => {
            // create the cards for each matchingActivity and insert in html
            // Example: Access the description, price, images, etc. from matchingActivity and display on your view
          const card = document.createElement('div');
          card.classList.add('activity-card');

          // Add activity details to the card
          const title = document.createElement('h3');
          title.textContent = matchingActivity.name;
          card.appendChild(title);

          const description = document.createElement('p');
          description.textContent = matchingActivity.description;
          card.appendChild(description);

          // Insert the card into your HTML element
          ul.appendChild(card);

          });
        } else {
          console.error("Invalid data format. Expected an array.");
        }
      });
  }





}



// get request for geocode


// `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(location)}&format=json`
