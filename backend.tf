#This is a backend coniguration

terraform {
   backend "gcs" {
    bucket = "my-tf-state-bucket-1"
    prefix = "terrafrom/state"
   }
}
