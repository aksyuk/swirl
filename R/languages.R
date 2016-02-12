swirl_language <- function(){
  lang <- getOption("swirl_language")
  langs <- c("chinese_simplified", "english", "french", "german", "korean", 
             "spanish", "turkish")
  
  if(is.null(lang) || !(lang %in% langs)){
    "english"
  } else {
    lang
  }
}

#' Select a language
#' 
#' Select a language for swirl's menus.
#' 
#' @param append_rprofile If \code{TRUE} this command will append 
#' \code{options(swirl_language = [selected language])} to the end of your 
#' Rprofile. The default value is \code{FALSE}.
#' 
#' @export
select_language <- function(append_rprofile = FALSE){
  langs <- c("chinese_simplified", "english", "french", "german", "korean", 
             "spanish", "turkish")
  selection <- select.list(langs)
  options(swirl_language = selection)
  
  if(append_rprofile){
    opts <- paste0("options(swirl_language = '", selection, "')")
    cat(opts, "\n", file = file.path("~", ".Rprofile"), append = TRUE)
  }
}

# set working directory to swirl repo before using
#' @importFrom yaml yaml.load_file
compile_languages <- function(){
  ctime <- as.integer(Sys.time())
  clone_dir <- file.path(tempdir(), ctime)
  dir.create(clone_dir, showWarnings = FALSE)
  git_clone <- paste("git clone https://github.com/swirldev/translations.git", clone_dir)
  system(git_clone)
  
  menus_dir <- file.path(clone_dir, "menus")
  menus <- list.files(menus_dir, pattern = "yaml$", full.names = TRUE)
  
  for(i in menus){
    lang_name <- sub(".yaml$", "", basename(i))
    cmd <- paste0(lang_name, " <- yaml.load_file('", i, "')")
    eval(parse(text=cmd))
  }
  
  comma_sep_langs <- paste(sub(".yaml$", "", basename(menus)), collapse = ", ")
  cmd <- paste0("save(", comma_sep_langs, ", file = file.path('R', 'sysdata.rda'))")
  eval(parse(text=cmd))
  unlink(clone_dir, recursive = TRUE, force = TRUE)
}

"%N%" <- function(f, y){
  result <- f(y)
  if(is.null(result)){
    y
  } else {
    result
  }
}

s <- function(){
  s_helper
}

s_helper <- function(x){
  cmd <- paste0(swirl_language(), "$`", x, "`")
  eval(parse(text=cmd))
}