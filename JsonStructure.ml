open Yojson.Basic

type file_tree =
  | File of string * string (* name, absolute path *)
  | Path of string
  | Directory of string * string * file_tree list (* name, absolute path, contents *)

let rec file_tree_to_json = function 
  | File (name, path) -> 
      `Assoc [
        ("type", `String "file"); 
        ("name", `String name); 
        ("path", `String path)
      ]
  | Path path -> `Assoc [("type", `String "path"); ("name", `String path)]
  | Directory (name, path, contents) ->
      `Assoc [
        ("type", `String "directory");
        ("name", `String name);
        ("path", `String path);
        ("contents", `List (List.map file_tree_to_json contents))
      ]

let ignore_dirs = [".git"; ".vscode"]

let rec read_directory base_path path =
  let full_path = Filename.concat base_path path in
  let items = Sys.readdir full_path |> Array.to_list in
  let items = List.map (fun item -> Filename.concat path item) items in
  let contents = List.filter_map (read_item base_path) items in
  Directory (Filename.basename path, full_path, contents)

and read_item base_path path =
  let name = Filename.basename path in
  let full_path = Filename.concat base_path path in
  if List.mem name ignore_dirs then
    None
  else if Sys.is_directory full_path then
    Some (read_directory base_path path)
  else
    Some (File (name, full_path))

let save_json_to_file json =
  let filename = "./structure.json" in 
  let json_string = Yojson.Basic.pretty_to_string json in
  let oc = open_out filename in
  output_string oc json_string;
  close_out oc

let () =
  let directory = "./Notes" in
  let file_tree = read_directory directory "" in
  let json = file_tree_to_json file_tree in
  save_json_to_file json