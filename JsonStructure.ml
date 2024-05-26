open Yojson.Basic
open Unix

type file_tree =
  | File of string * string * string (* name, absolute path, modification time *)
  | Path of string
  | Time of string  (* name, time *)
  | Directory of string * string * file_tree list (* name, absolute path, contents *)

let format_modification_time time =
  let tm = Unix.gmtime time in
  Printf.sprintf "%04d-%02d-%02d" (1900 + tm.tm_year) (tm.tm_mon + 1) tm.tm_mday

let rec file_tree_to_json = function 
  | File (name, path, mod_time) -> 
      `Assoc [
        ("type", `String "file"); 
        ("name", `String name); 
        ("path", `String path);
        ("time", `String mod_time)
      ]
  | Path path -> `Assoc [("type", `String "path"); ("name", `String path)]
  | Time time -> `Assoc [("type", `String "time"); ("name", `String time)]
  | Directory (name, path, contents) ->
      `Assoc [
        ("type", `String "directory");
        ("name", `String name);
        ("path", `String path);
        ("contents", `List (List.map file_tree_to_json contents))
      ]

let ignore_dirs = [".git"; ".vscode"]

let rec read_directory base_path root_path path =
  let full_path = Filename.concat base_path path in
  let items = Sys.readdir full_path |> Array.to_list in
  let items = List.map (fun item -> Filename.concat path item) items in
  let contents = List.filter_map (read_item base_path root_path) items in
  Directory (Filename.basename path, Filename.concat root_path path, contents)

and read_item base_path root_path path =
  let name = Filename.basename path in
  let full_path = Filename.concat base_path path in
  if List.mem name ignore_dirs then
    None
  else if Sys.is_directory full_path then
    Some (read_directory base_path root_path path)
  else
    let stats = Unix.stat full_path in
    let mod_time = format_modification_time stats.st_mtime in
    Some (File (name, Filename.concat root_path path, mod_time))

let save_json_to_file json =
  let filename = "./structure.json" in 
  let json_string = Yojson.Basic.pretty_to_string json in
  let oc = open_out filename in
  output_string oc json_string;
  close_out oc

let () =
  let base_directory = "./Notes" in
  let root_directory = "Notes/Notes" in
  let file_tree = read_directory base_directory root_directory "" in
  let json = file_tree_to_json file_tree in
  save_json_to_file json