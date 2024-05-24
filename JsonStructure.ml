open Yojson.Basic

type file_tree =
  | File of string
  | Directory of string * file_tree list

let rec file_tree_to_json = function 
  | File name -> `Assoc [("type", `String "file"); ("name", `String name)]
  | Directory (name, contents) ->
      `Assoc [
        ("type", `String "directory");
        ("name", `String name);
        ("contents", `List (List.map file_tree_to_json contents))
      ]

let ignore_dirs = [".git"; ".vscode"]

let rec read_directory path =
  let items = Sys.readdir path |> Array.to_list in
  let items = List.map (fun item -> Filename.concat path item) items in
  let contents = List.filter_map read_item items in
  Directory (Filename.basename path, contents)

and read_item path =
  let name = Filename.basename path in
  if List.mem name ignore_dirs then
    None
  else if Sys.is_directory path then
    Some (read_directory path)
  else
    Some (File name)

let save_json_to_file json =
  let filename = "./structure.json" in 
  let json_string = Yojson.Basic.pretty_to_string json in
  let oc = open_out filename in
  output_string oc json_string;
  close_out oc

let () =
    let directory = "./Notes" in
    let file_tree = read_directory directory in
    let json = file_tree_to_json file_tree in
    save_json_to_file json 