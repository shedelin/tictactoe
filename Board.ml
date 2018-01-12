(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Board.ml                                           :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: rbernand <marvin@42.fr>                    +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/19 20:41:40 by rbernand          #+#    #+#             *)
(*   Updated: 2015/06/21 19:44:13 by rbernand         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)


module Cell =
    struct
        type value = Empty | O | X | WIN_X | WIN_O
        type t = value * int

        let value_from_player t = match t with
            | Player.P1        -> O
            | Player.P2        -> X

        let getWinValue player = match player with
            | Player.P1		-> WIN_O
            | Player.P2		-> WIN_X

        let get_string_from_pos_X v = match v with
            | 0 | 8             -> "\\ "
            | 1 | 3 | 5 | 7     -> "  "
            | 2 | 6             -> "/ "
            | 4                 -> "X "
            | _                 -> "* "

        let get_string_from_pos_O v = match v with
            | 0 | 8             -> "/ "
            | 3 | 5             -> "| "
            | 1 | 7             -> "- "
            | 2 | 6             -> "\\ "
            | 4                 -> "  "
            | _                 -> "* "

        let toString t = match t with
            | (Empty, _)     -> "- "
            | (O, _)         -> "\027[31m0 \027[0m"
            | (X, _)         -> "\027[32mX \027[0m"
            | (WIN_X, a)     -> "\027[32m" ^ (get_string_from_pos_X a) ^
            "\027[0m"
            | (WIN_O, a)     -> "\027[31m" ^ (get_string_from_pos_O a) ^
            "\027[0m"

        let newCell ?value:(v=Empty) n = (v, n)

        let getValue t = match t with
            |(a, _)     -> a
        let getPosition t = match t with
            |(_, a)     -> a

        let get_cell_value pos =
            ((pos mod 27) / 9) * 3 + pos mod 3
    end

module SubZone =
    struct
        type t = Cell.value list
        type value = WIN_X | WIN_O | None

        let check value_lst =
            let loop_check t1 = match t1 with
                | []                                                                      -> false
                | a::_::_::_::_::_::_::_::_ when a = Cell.WIN_O ||  a = Cell.WIN_X        -> false
                | a::b::c::_::_::_::_::_::_ when a <> Cell.Empty && (a = b && b = c)      -> true
                | a::_::_::b::_::_::c::_::_ when a <> Cell.Empty && (a = b && b = c)      -> true
                | a::_::_::_::b::_::_::_::c::e when a <> Cell.Empty && (a = b && b = c)   -> true
                | _::a::_::_::b::_::_::c::_ when a <> Cell.Empty && (a = b && b = c)      -> true
                | _::_::a::_::_::b::_::_::c::e when a <> Cell.Empty && (a = b && b = c)   -> true
                | _::_::_::a::b::c::_::_::_ when a <> Cell.Empty && (a = b && b = c)      -> true
                | _::_::_::_::_::_::a::b::c::e when a <> Cell.Empty && (a = b && b = c)   -> true
                | _::_::a::_::b::_::c::_::_ when a <> Cell.Empty && (a = b && b = c)      -> true
                | _                                                                       -> false
            in
            loop_check value_lst

        let get_value l =  match l with
            | []            -> invalid_arg "empty list"
            | a::e     ->  if a = Cell.WIN_X then
                                    WIN_X
                                else if a = Cell.WIN_O then
                                    WIN_O
                                else
                                    None

        let extract_list_value lst =
            let rec loop l acc = match l with
                | []            -> acc
                | a::e          -> loop e (acc @ [get_value a])
            in
            loop lst []
        
        let rec is_fool lst n = match lst with
            | [] when n = 8 -> true
            | []            -> false
            | a::b when (a = Cell.O) || (a = Cell.X)    -> is_fool b (n + 1)
            | a::b          -> is_fool b n

    end

type t = Cell.t list

let is_empty t pos =
    let rec loop tt i = match tt with
        | []                        -> false
        | (a, _)::e when pos = i    -> a = Cell.Empty
        | a::e                      -> loop e (i + 1)
    in loop t 0

let newBoard () =
    let rec loop n acc =
        if n = 81 then
            acc
        else
            begin
            loop (n + 1) ((Cell.newCell (((n mod 27) / 9) * 3 + (n mod 3)))::acc)
            end
    in
    loop 0 []

let extract l n =
    let rec sub_loop l2 i acc = match l2 with
        | []            -> acc
        | a::b when ( i = 0 || i = 1 || i = 2 || i = 9 || i = 10 || i = 11 || i = 18 || i = 19 || i = 20 )
            -> sub_loop b (i + 1) (acc @ [Cell.getValue a])
        | _::b          -> sub_loop b (i + 1) acc
    in
    let break = ((n / 3) * 27) + ((n mod 3) * 3) in
    let rec loop_extract l1 i = match l1 with
        | []                    -> invalid_arg "out of range"
        | a::b when i = break   -> sub_loop (a::b) 0 []
        | a::b                  -> loop_extract b (i + 1)
    in
    loop_extract l 0

let toString t =
    let rec loop t n str = match t with 
        | []                        -> "1 2 3   4 5 6   7 8 9\n" ^ "------+-------+------\n" ^ str
        | a::b when (n mod 27) = 26 -> loop b (n + 1) (str ^ (Cell.toString a)
                        ^ (string_of_int ((n / 9) + 1)) ^ "\n------+-------+------\n")
        | a::b when (n mod 3) = 2   -> if (n mod 9) = 8 then 
                                           loop b (n + 1) (str ^ Cell.toString a
                                           ^ (string_of_int ((n / 9) + 1)) ^"\n")
                                       else
                                           loop b (n + 1) (str ^ Cell.toString a
                                           ^"| ")
        | a::b                      -> loop b (n + 1) (str ^ Cell.toString a)
    in
    loop t 0 ""

let extract_list board =
    let rec loop board i acc =
        if (i > 8)
            then acc
        else
            loop board (i + 1) (acc @ [extract board i])
    in
    loop board 0 []

let check lsz =
    let loop_check_lsz l = match l with
        | []                                                                -> true
        | a::b::c::_::_::_::_::_::_ when a <> SubZone.None && (a = b && b = c)      -> false
        | a::_::_::b::_::_::c::_::_ when a <> SubZone.None && (a = b && b = c)      -> false
        | a::_::_::_::b::_::_::_::c::e when a <> SubZone.None && (a = b && b = c)      -> false
        | _::a::_::_::b::_::_::c::_ when a <> SubZone.None && (a = b && b = c)      -> false
        | _::_::a::_::_::b::_::_::c::e when a <> SubZone.None && (a = b && b = c)      -> false
        | _::_::_::a::b::c::_::_::_ when a <> SubZone.None && (a = b && b = c)      -> false
        | _::_::_::_::_::_::a::b::c::e when a <> SubZone.None && (a = b && b = c)      -> false
        | _::_::a::_::b::_::c::_::_ when a <> SubZone.None && (a = b && b = c)      -> false
        | _                                                                 -> true
    in
    loop_check_lsz lsz

let rec isFull values= match values with
    | []            -> true
    | a::b when a = SubZone.None    -> false
    | a::b when a = SubZone.WIN_O    -> isFull b 
    | a::b when a = SubZone.WIN_X    -> isFull b
    | _::b                          -> invalid_arg "poney"

let update board n value =
    let rec loop_create_new_board b i acc = match b with
        | []    -> acc
        | a::b when ( i = (n + 0) || i = (n + 1) || i = (n + 2) || i = (n + 9) || i = (n + 10) || i = (n + 11) || i = (n + 18) || i = (n + 19) || i = (n + 20) ) 
                -> loop_create_new_board b (i + 1) (acc @ [Cell.newCell
                ~value:value (Cell.getPosition a)])
        | a::b  -> loop_create_new_board b (i + 1) (acc @ [a])
    in
    loop_create_new_board board 0 []

let update_game board player =
    let lsz = extract_list board in
    let rec loop_update lsz n = match lsz with
        | [] -> board
        | a::b when (SubZone.check a) -> update board ((((n / 3) * 27) + (n mod
        3) * 3)) (Cell.getWinValue player)
        | a::b when ((SubZone.check a) || (SubZone.is_fool a 0)) -> update board
        ((((n / 3) * 27) + (n mod 3) * 3)) (Cell.getWinValue player)
        | _::b -> loop_update b (n + 1)
    in
    loop_update lsz 0

let play t pos value =
    let rec loop t n acc = match t with
        | []                        -> invalid_arg "Invalid position"
        | (_, a)::e when n = pos    -> acc @ ((Cell.newCell ~value:value a)::e)
        | a::e                      -> loop e (n + 1) (acc @ (a::[]))
        in
        loop t 0 []
