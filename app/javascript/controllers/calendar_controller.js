import { Controller } from "@hotwired/stimulus";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import jaLocale from "@fullcalendar/core/locales/ja";
import rrulePlugin from "@fullcalendar/rrule";

// Connects to data-controller="calendar"
export default class extends Controller {
  static values = { events: Array }
  connect() {
    const calendar = new Calendar(this.element, {
      plugins: [dayGridPlugin, rrulePlugin],
      initialView: "dayGridMonth",
      locale: jaLocale,
      events: this.eventsValue,
      eventClick: function(info) {
        if (info.event.url) {
          info.jsEvent.preventDefault()
          window.location.href = info.event.url
        }
      }
    })
    calendar.render()
  }
}
