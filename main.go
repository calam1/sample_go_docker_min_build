package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	fmt.Println("vim-go")
	router := mux.NewRouter()

	router.HandleFunc("/name/{name}", func(w http.ResponseWriter, r *http.Request) {
		n := mux.Vars(r)["name"]
		fmt.Fprintf(w, "Hi my name is %s\n", n)
	})

	http.ListenAndServe(":8000", router)
}
