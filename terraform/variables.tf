variable "hack_s3_bucket" {
    type = string
    default = "nuwe-zurich-cloud-hack-bucket-teamrain"
  
}


variable "hack_lambda_name" {
    type = string
    default = "hackathon_lambda"
  
}

variable "lambda_src_code_path" {
    type = string
    default = "../hack_lambda_function.zip"
  
}

variable "dynamodb_table_name" {
    type = string
    default = "hackthon_dynamodb_table"
  
}

variable "dynamodb_table_attb" {
    type = map(string)
    default = {
      "primary_key" = "customer_id"
      "secondry_key" = "customer_name"
    }
  
}

variable "hackathon_tags" {
    type = map(string)
    default = {
      Name        = "Zurich-Hackathon-resources"
      Environment = "Dev"
    }
    
  
}