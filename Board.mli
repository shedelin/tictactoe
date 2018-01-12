(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Board.mli                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: rbernand <marvin@42.fr>                    +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/19 20:28:30 by rbernand          #+#    #+#             *)
(*   Updated: 2015/06/21 19:29:45 by rbernand         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module Cell :
sig
    type value
    type t

    val getWinValue : Player.t -> value
    val toString : t -> string
    val newCell : ?value:value -> int -> t
    val getValue : t -> value
    val value_from_player : Player.t -> value
    val getPosition : t -> int
end

module SubZone :
sig
	type t
    type value

	val check : t -> bool
    val extract_list_value : t list -> value list
    val is_fool : t -> int -> bool
end

type t
val newBoard : unit -> t
val toString : t -> string
val extract_list : t -> SubZone.t list
val play : t -> int -> Cell.value -> t
val check : SubZone.value list -> bool
val is_empty : t -> int -> bool
val update_game : t -> Player.t -> t
val isFull : SubZone.value list -> bool
