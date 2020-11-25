variable "WORDPRESS_DB_USER" {
    type = string
    description = "WordPress User"  
    default = "root"
}

variable "WORDPRESS_DB_PASSWORD" {
    type = string
    description = "WordPress Pass"
    default = "changeit"
}

variable "WORDPRESS_DB_NAME" {
    type = string
    description = "DB Name"
    default = "changeit"
}