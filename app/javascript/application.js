// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// app/javascript/application.js
import "@hotwired/turbo-rails"
const application = Application.start()
import { Application } from "@hotwired/stimulus"
import SwiperController from "./controllers/swiper_controller"
import HelloController from "./controllers/hello_controller"
import MenuToggleController from "./controllers/menu_toggle_controller"
import ResetFormController from "./controllers/reset_form_controller"
import DiagnosisController from "./controllers/diagnosis_controller"
import LoadingController from "./controllers/loading_controller"
import PreviewController from "./controllers/preview_controller"
import ScrollController from "./controllers/scroll_controller"

application.register("swiper", SwiperController)
application.register("hello", HelloController)
application.register("menu-toggle", MenuToggleController)
application.register("reset-form", ResetFormController)
application.register("diagnosis", DiagnosisController)
application.register("loading", LoadingController)
application.register("preview", PreviewController)
application.register("scroll", ScrollController)

import "./channels"
