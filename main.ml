(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   main.ml                                            :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: rbernand <marvin@42.fr>                    +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/19 20:27:43 by rbernand          #+#    #+#             *)
(*   Updated: 2015/06/21 19:43:27 by rbernand         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Parser =
    struct
        let is_digit = function
            | '1' .. '9'    -> true
            | _             -> false

        let test_string (s:string) =
            let len = String.length s in
            if len <> 3 then false else
            if is_digit s.[0] && (s.[1] = ' ') && is_digit s.[2]
                then true
            else
                false

        let parse_string (str:string) =
            if (test_string str) then
                (((int_of_char str.[0]) - int_of_char '1') * 9) + ((int_of_char
                str.[2]) - int_of_char '1')
            else begin
                Printf.printf "Invalid format\n"; -1
            end

        let get_input player =
            if player = Player.P1 then
                Printf.printf "Player 1 play :\n"
            else
                Printf.printf "Player 2 play :\n";
            parse_string (read_line ())
   end

let min_max () = Random.int 81
module Game =
    struct
        type t = { board : Board.t; player : Player.t }
        let newGame () = { board = Board.newBoard (); player = Player.P1}

(*        let prompt board player =
            let rec loop id = match id with
                | -1                    -> loop (min_max ())
                | _ when (Board.is_empty board id) = false -> Printf.printf
                "Cell %d is not Empty\n" id; loop (min_max ())
                | _                     -> id
            in
            loop (min_max ())
*)
        let prompt board player =
            let rec loop id = match id with
                | -1                    -> loop (Parser.get_input player)
                | _ when (Board.is_empty board id) = false -> Printf.printf
                "Cell not Empty\n"; loop (Parser.get_input player)
                | _                     -> id
            in
            loop (Parser.get_input player)

        let print t = print_endline (Board.toString t.board)

        let rec main_loop ?state:(state=false) board player = match state with
            | false             -> Printf.printf "%s\n" (Board.toString board); Player.playerNext player
            | true              -> begin
                Printf.printf "\027[2J\027[1;1H%s\n" (Board.toString board);
                let id = prompt board player in
                Printf.printf "%s play in %d\n" (Player.toString player) id;
                let new_board = Board.play board id (Board.Cell.value_from_player player) in
                let bb = Board.update_game new_board player in
                let values = Board.SubZone.extract_list_value
                (Board.extract_list bb) in
                main_loop ~state:((Board.check values) && (not (Board.isFull
                values))) bb (Player.playerNext player)
            end
    end 

let rec main () =
    Random.self_init ();
    let winner = Game.main_loop ~state:true (Board.newBoard ()) Player.P1
    in
    Printf.printf "%s win!\n" (Player.toString winner);
    Printf.printf "Restart? [y/n]\n";
    let c = (read_line ()).[0] in
    if c = 'y' || c = 'Y' then
        main ()
    else
        Printf.printf "Thank You for playing\n"

let () = main ()
