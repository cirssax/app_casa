# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_11_171607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "descrip_marca", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["descrip_marca"], name: "index_brands_on_descrip_marca", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "nombre_producto", default: "", null: false
    t.integer "marca", null: false
    t.integer "tipo", null: false
    t.integer "stock", default: 0, null: false
    t.string "ubicacion", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "fecha", null: false
    t.integer "cantidad", default: 0, null: false
    t.integer "estado", null: false
    t.integer "usuario", null: false
    t.integer "producto", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "descrip_rol", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["descrip_rol"], name: "index_roles_on_descrip_rol", unique: true
  end

  create_table "situations", force: :cascade do |t|
    t.string "descrip_estado_producto", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["descrip_estado_producto"], name: "index_situations_on_descrip_estado_producto", unique: true
  end

  create_table "states", force: :cascade do |t|
    t.string "descrip_estado", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["descrip_estado"], name: "index_states_on_descrip_estado", unique: true
  end

  create_table "stories", force: :cascade do |t|
    t.string "semana", default: "", null: false
    t.integer "cantidad", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "types", force: :cascade do |t|
    t.string "descrip_tipo", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["descrip_tipo"], name: "index_types_on_descrip_tipo", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "login", default: "", null: false
    t.string "nombre_usuario", default: "", null: false
    t.string "apellidos_usuario", default: "", null: false
    t.integer "rol", null: false
    t.integer "estado", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apellidos_usuario"], name: "index_users_on_apellidos_usuario", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["nombre_usuario"], name: "index_users_on_nombre_usuario", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "products", "brands", column: "marca"
  add_foreign_key "products", "types", column: "tipo"
  add_foreign_key "requests", "products", column: "producto"
  add_foreign_key "requests", "situations", column: "estado"
  add_foreign_key "requests", "users", column: "usuario"
  add_foreign_key "users", "roles", column: "rol"
  add_foreign_key "users", "states", column: "estado"
end
