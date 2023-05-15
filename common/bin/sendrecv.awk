/35=/ { 
    gsub("", " ")
    gsub(" 35=", "\n &")
    gsub(" 55=", "\n   &")
    print
}
