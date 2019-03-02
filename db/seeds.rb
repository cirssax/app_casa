# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Roles de usuarios
Role.destroy_all
Role.create!([
                 {
                     descrip_rol: "ADMINISTRADOR"
                 },
                 {
                     descrip_rol: "VENDEDOR"
                 }
             ])
p "Created #{Role.count} entries"
#Estados de usuarios
State.destroy_all
State.create!([
                  {
                      descrip_estado: "ACTIVO"
                  },
                  {
                      descrip_estado: "DESACTIVADO"
                  }
              ])
p "Created #{State.count} entries"
#Estados de productos en consumo
Situation.destroy_all
Situation.create!([
                      {
                          descrip_estado_producto: "EN CONSUMO"
                      },
                      {
                          descrip_estado_producto: "SIN CONSUMIR"
                      }
                  ])
p "Created #{Situation.count} entries"
#Usuarios
User.destroy_all
User.create!([
                 {
                     email: "admin@admin.org",
                     password: '1234qwer',
                     password_confirmation: '1234qwer',
                     rol: (Role.find_by_descrip_rol("ADMINISTRADOR")).id,
                     estado: (State.find_by_descrip_estado("ACTIVO")).id,
                     nombre_usuario: "CRISTOBAL IGNACIO",
                     apellidos_usuario: "SALDIAS ROJAS",
                     login: "ADMIN"
                 },
                 {
                     email: "cristobal.saldias@gmail.com",
                     password: '1234qwer',
                     password_confirmation: '1234qwer',
                     rol: (Role.find_by_descrip_rol("VENDEDOR")).id,
                     estado: (State.find_by_descrip_estado("ACTIVO")).id,
                     nombre_usuario: "RICARDO ANTONIO",
                     apellidos_usuario: "SALDIAS ALVAREZ",
                     login: "RSALDIAS"
                 }
             ])
p "Created #{User.count} entries"
#Tipos de productos
Type.destroy_all
Type.create!([
                 {
                     descrip_tipo: "HIGIENE"
                 },
                 {
                     descrip_tipo: "OFICINA"
                 },
                 {
                     descrip_tipo: "DEPORTE"
                 },
                 {
                     descrip_tipo: "ESCOLAR"
                 },
                 {
                     descrip_tipo: "ELECTRONICOS"
                 },
                 {
                     descrip_tipo: "COCINA"
                 },
                 {
                     descrip_tipo: "ROPA"
                 },
                 {
                     descrip_tipo: "ABARROTES"
                 }
             ])
p "Created #{Type.count} entries"

#Semillas para las marcas de los productos
Brand.destroy_all
Brand.create!([
                  {
                      descrip_marca: "GENERAL ELECTRICS"
                  },
                  {
                      descrip_marca: "TUCAPEL"
                  },
                  {
                      descrip_marca: "SIN MARCA"
                  },
                  {
                      descrip_marca: "PILOT"
                  },
                  {
                      descrip_marca: "BIC"
                  },
                  {
                      descrip_marca: "CONFORT"
                  },
                  {
                      descrip_marca: "MAPED"
                  },
                  {
                      descrip_marca: "LESANCI"
                  },
                  {
                      descrip_marca: "REXONA"
                  },
                  {
                      descrip_marca: "ELITE"
                  },
                  {
                      descrip_marca: "CAROZZI"
                  }
              ])
p "Created #{Brand.count} entries"