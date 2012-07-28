open Lwt

let stats_server_name = "http://ec2-107-20-107-204.compute-1.amazonaws.com"
let stats_server_port = 1080

lwt stats_dst = try_lwt
  let hent = Unix.gethostbyname stats_server_name in
  return (Unix.ADDR_INET (hent.Unix.h_addr_list.(0), stats_server_port))
with _ ->
  raise_lwt (Failure ("cannot resolve " ^ stats_server_name))

let get_current_time_str =
  let timestamp = Unix.gmtime(Unix.time()) in
  let time_str = Printf.sprintf "%d-%d-%dT%d:%d:%dZ" timestamp.Unix.tm_year
    timestamp.Unix.tm_mon timestamp.Unix.tm_mday timestamp.Unix.tm_hour
    timestamp.Unix.tm_min timestamp.Unix.tm_sec in
  time_str

let stats_message client_id message_time dataField data = 
  let open Json in
  let message = Json.Object
    [("type", Json.String "stats"); 
     ("time", Json.String message_time); 
     ("data", Json.Object 
       [("node", Json.String client_id);
        (dataField, Json.Float data)]
     )] in
  let message_str = Json.to_string message in
  message_str

let send_downstream_bandwidth client_id bw =
  let open Json in
  let current_time = get_current_time_str in
  let message = stats_message client_id current_time "bandwidth" bw in
  Udp_server.send_datagram message stats_dst

let send_client_latency client_id latency = 
  let open Json in
  let current_time = get_current_time_str in
  let message = stats_message client_id current_time "latency" latency in
  Udp_server.send_datagram message stats_dst

let send_jitter client_id jitter = 
  let open Json in
  let current_time = get_current_time_str in
  let message = stats_message client_id current_time "jitter" jitter in
  Udp_server.send_datagram message stats_dst
