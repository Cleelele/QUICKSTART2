import { Controller } from "@hotwired/stimulus";
import yaml from "js-yaml";

export default class extends Controller {
  static targets = ["input", "form", "lid"];
  token = null;
  location = null;
  matchingTags = [];
  filteredActivities = [];

  connect() {
    this.getApiKey();
    this.loadMatchingTags();
    document.addEventListener('click', this.handleClick.bind(this));
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

  getLocation(event) {
    event.preventDefault()
    const form = event.currentTarget;
    const addressInput = form.querySelector('input[data-event-target="input"]');
    const address = addressInput.value;
    const urlAddress = `https://nominatim.openstreetmap.org/search?q=${encodeURIComponent(address)}&format=json`;
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
    formData.append('client_id', '9ulXYrcAbq4ApwJ2kO3rab85s05Sk5OL');
    formData.append('client_secret', 'GyG2eGE7X6BEmUIO');
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
      console.log("unfiltered activities>>", data)
      if (Array.isArray(data.data)) {
        this.filteredActivities = data.data.filter((activity) => {
          if (Array.isArray(activity.tags)) {
            return activity.tags.some((tag) => this.matchingTags.includes(tag));
          } else {
            return false;
          }
        });
        console.log("Filtered Activities>>>", this.filteredActivities);
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
        console.log("detailed data>>", data)
        if (Array.isArray(data.data)) {
          const detailedActivities = data.data || [];
          const matchingActivities = [];

          this.filteredActivities.forEach((filteredActivity) => {
            const filteredActivityName = filteredActivity.name.toLowerCase();

            const activitiesMatchingName = detailedActivities.filter((detailedActivity) => {
              const detailedActivityName = detailedActivity.name.toLowerCase();
              const detailedActivityDescription = detailedActivity.description ? detailedActivity.description.toLowerCase() : '';

              return (
                detailedActivityName.includes(filteredActivityName) || detailedActivityDescription.includes(filteredActivityName)
              );
            });

            if (activitiesMatchingName.length > 0) {
              matchingActivities.push(...activitiesMatchingName);
            }
          });

          // Find the UL element by its id
          const ul = document.getElementById('activity-cards');

            // Remove any existing activities
          ul.innerHTML = '';

          console.log("matching activities 1>>", matchingActivities)
          // Display information for the matching activities
          matchingActivities.forEach((matchingActivity) => {
            // create the cards for each matchingActivity and insert in html
            // Example: Access the description, price, images, etc. from matchingActivity and display on your view
            const card = document.createElement('div');
            card.classList.add('activity-card');

            // Add activity details to the card
            const link = document.createElement("a");
            link.href = '/events';
            link.textContent = "View more";
            link.setAttribute("data-activity-name", matchingActivity.name);
            link.setAttribute("data-activity-price", matchingActivity.price.amount);
            link.setAttribute("data-activity-description", matchingActivity.description);
            link.setAttribute("data-activity-img", matchingActivity.pictures[0]);
            link.setAttribute("data-activity-category", matchingActivity.type);
            link.classList.add("btn", "btn-primary", "add-activity-link");
            // link.setAttribute("data-action", "click->event#createActivity");
            card.appendChild(link);

            const img = document.createElement("img");
            if(matchingActivity.pictures.length === 0) {
              img.src = "https://res.cloudinary.com/divn1ky6d/image/upload/v1686668590/quickstart_logo_sati1q.png"
            }else{
              img.src = matchingActivity.pictures[0];
            }
            card.appendChild(img);

            const title = document.createElement('h5');
            title.textContent = matchingActivity.name;
            card.appendChild(title);


            // Insert the card into your HTML element
            ul.appendChild(card);

          });
        } else {
          console.error("Invalid data format. Expected an array.");
        }
      });
  }

  createActivity(event) {
    event.preventDefault();
    const link = event.target;
    const activityName = link.getAttribute("data-activity-name");
    const activityPrice = link.getAttribute("data-activity-price");
    const activityCategory = link.getAttribute("data-activity-category");
    const activityDescription = link.getAttribute("data-activity-description");
    const activityImg = link.getAttribute("data-activity-img");

    const address = this.inputTarget.value;
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    const data = {
      name: activityName,
      price: activityPrice,
      category: activityCategory,
      description: activityDescription,
      address: address,
      image: activityImg
    };

    console.log("Create Activity Data:", data);

    fetch('/events', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify(data),
    })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error('Failed to create event');
        }
      })
      .then((responseData) => {
        //window.location.href = "https://google.com"; // Redirect to the show page
      })
      .catch((error) => {
        const event_last = document.getElementById("laste");
        window.location.href = `/events/${parseInt(event_last.innerText) + 1}`;
        console.error("Failed to create event:", error);
      });
  }


  addEventListeners() {
    const links = this.element.querySelectorAll('.add-activity-link');
    links.forEach((link) => {
      link.addEventListener('click', this.createActivity.bind(this));
    });
  }

  handleClick(event) {
    if (event.target.matches('.add-activity-link')) {
      event.preventDefault();
      this.createActivity(event);
    }
  }
}
