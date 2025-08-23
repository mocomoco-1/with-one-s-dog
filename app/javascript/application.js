// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// app/javascript/application.js
import { Application } from "@hotwired/stimulus"

import HelloController from "./controllers/hello_controller"
import MenuToggleController from "./controllers/menu_toggle_controller"
import ResetFormController from "./controllers/reset_form_controller"

const application = Application.start()
application.register("hello", HelloController)
application.register("menu-toggle", MenuToggleController)
application.register("reset-form", ResetFormController)

import "./channels"
