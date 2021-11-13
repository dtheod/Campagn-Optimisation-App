


hash_pass <- function(input_password){
  hash <- digest(input_password, algo="md5", serialize=F)
  return(hash)
}


auth_api <- function(input_username){
  
  result = tryCatch ({
    con <- dbConnect(RSQLite::SQLite(), ".//Data/campaing_db.sqlite")
    query = paste0("SELECT Username, Password FROM Users WHERE Username = '", input_username,"'")
    users_table = dbGetQuery(con, query)
    print(users_table)
    dbDisconnect(con)
  },
  error = function(){
    message("Username does not exist")
    return(NULL)
  },
  warning = function(){
    message("Database warnings")
    return(NULL)
  },
  finally = {
    message("Done")
  })
  return(users_table)
  
}

check <- function(input_password, input_username){
  
  resutl_api <- auth_api(input_username)

  if (nrow(resutl_api) != 0){
    actual_pass = resutl_api$Password
    actual_username = resutl_api$Username
    hashed_password = hash_pass(input_password)
    if (hashed_password == actual_pass){
      return(TRUE)
    } else{
      return(FALSE)
    }
  } else {
    return(FALSE)
  }
  return(FALSE)
}


conversions_all <- function(){
  
  leads <- dbGetQuery(con, "SELECT * FROM Lead_Demography")
  markets <- dbGetQuery(con, "SELECT * FROM Market_Touchdown")
  return(markets)
  
}



