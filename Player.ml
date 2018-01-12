(* ************************************************************************** *)
(*                                                                            *)
(*                                                        :::      ::::::::   *)
(*   Player.ml                                          :+:      :+:    :+:   *)
(*                                                    +:+ +:+         +:+     *)
(*   By: rbernand <marvin@42.fr>                    +#+  +:+       +#+        *)
(*                                                +#+#+#+#+#+   +#+           *)
(*   Created: 2015/06/21 16:02:11 by rbernand          #+#    #+#             *)
(*   Updated: 2015/06/21 17:15:01 by rbernand         ###   ########.fr       *)
(*                                                                            *)
(* ************************************************************************** *)

module type PLAYER =
    sig
        type t = P1 | P2

        val toString : t -> string
    end

module Human : PLAYER =
    struct
        type t = P1 | P2

        let playerNext player = match player with
             | P1        -> P2
             | P2        -> P1

        let toString player = match player with
            | P1        -> "Player 1"
            | P2        -> "Player 2"
    end

module Ia : PLAYER =
    struct
        type t = P1 | P2

        let playerNext player = match player with
             | P1        -> P2
             | P2        -> P1

        let toString player = match player with
            | P1        -> "IA 1"
            | P2        -> "IA 2"
    end

   
     type t = P1 | P2
        let playerNext player = match player with
             | P1        -> P2
             | P2        -> P1


        let toString player = match player with
            | P1        -> "Player 1"
            | P2        -> "Player 2"
